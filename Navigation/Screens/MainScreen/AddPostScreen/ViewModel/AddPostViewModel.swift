//
//
// AddPostViewModelNew.swift
// Navigation
//
// Created by Александр Востриков
//


import UIKit

final class AddPostViewModel {
    
    let title = "APVM.title".localized
    var onUpdate: () -> Void = {}
    
    enum Cell {
        case bodyImageView(BodyImageViewCellViewModel)
    }
    
    private(set) var cells: [Cell] = []
    weak var coordinator: ProfileCoordinator!
    
    private var bodyCellViewModel: BodyImageViewCellViewModel?
    private var postImageCellViewModel: BodyImageViewCellViewModel?
    private let cellBuilder: PostCellBuilder
    private let firestore: DatabeseManagerProtocol
    private let userService: UserService
    
    init(cellBuilder: PostCellBuilder,
         firestore: DatabeseManagerProtocol,
         userService: UserService
    ) {
        self.cellBuilder = cellBuilder
        self.firestore = firestore
        self.userService = userService
        Logger.standart.start(on: self)
    }
    
    func viewDidLoad() {
        setupCells()
        onUpdate()
    }
    
    func viewDidDisappear() {
        coordinator?.didFinish()
    }
    
    func numberOfRows() -> Int {
        cells.count
    }
    
    func cell(for indexPath: IndexPath) -> Cell {
        cells[indexPath.row]
    }
    
    func tappedDone() {
        guard let bodyText = bodyCellViewModel?.bodyText, !bodyText.isEmpty else { return }
        let user = userService.getUser()
        let filename = "\(user.uid)_\(Date())_postImage"
        if let postImage = postImageCellViewModel?.image {
            #warning("weak self is nil")
            //Если ослабить self метод не вызывается, так как self становится nil
            uploadImage(image: postImage, fileName: filename) {  result in
                switch result {
                    case .success(let url):
                        self.addPost(with: user.uid, bodyText: bodyText, and: url)
                    case .failure(let error):
                        print("error uploadImage:\(error)")
                }
            }
        } else {
            addPost(with: user.uid, bodyText: bodyText, and: nil)
        }
        coordinator.didFinishSavePost()
    }
    func addImage() {
        coordinator?.showImagePicker() { [weak self] image in
            guard let self else { return }
            if let image {
                if self.cells.count == 1 {
                    let postImageCellViewModel = self.updateImage(with: image)
                    self.cells.append(.bodyImageView(postImageCellViewModel))
                    self.onUpdate()
                } else {
                    let postImageCellViewModel = self.updateImage(with: image)
                    self.cells[1] = .bodyImageView(postImageCellViewModel)
                    self.onUpdate()
                }
            }
        }
    }
    func updateCell(indexPath: IndexPath, text: String) {
        switch cells[indexPath.row] {
            case .bodyImageView(let bodyImageViewCellViewModel):
                bodyImageViewCellViewModel.update(text)
        }
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        switch cells[indexPath.row] {
            case .bodyImageView(let bodyImageViewCellViewModel):
                guard bodyImageViewCellViewModel.type == .image else { return }
                coordinator?.showImagePicker() { [weak self] image in
                    guard let image else { return }
                    bodyImageViewCellViewModel.update(image)
                    self?.onUpdate()
                }
        }
    }
    deinit {
        Logger.standart.remove(on: self)
    }
}

private extension AddPostViewModel {
    func updateImage(with image: UIImage) -> BodyImageViewCellViewModel {
        let postImageCellViewModel = cellBuilder.makeBodyImageViewCellViewModel(.image)
        postImageCellViewModel.update(image)
        self.postImageCellViewModel = postImageCellViewModel
        return postImageCellViewModel
    }
    
    func setupCells() {
        bodyCellViewModel = cellBuilder.makeBodyImageViewCellViewModel(.text)
        guard let bodyCellViewModel = bodyCellViewModel else { return }
        cells = [.bodyImageView(bodyCellViewModel)]
    }
    
    func uploadImage(image: UIImage, fileName: String, completion: @escaping (Result<String, Error>)-> Void) {
        guard let imageData = image.jpegData(compressionQuality: 100) else { return }
        firestore.uploadPostPicture(with: imageData, fileName: fileName) { result in
            completion(result)
        }
    }
    func addPost(with userUid: String, bodyText: String, and url: String?) {
        let post = Post(userUid: userUid, body: bodyText, imageUrl: url, likes: [], views: 0, createdDate: Date(), updateDate: Date())
        firestore.addNewPost(post: post) { error in
            guard let error else { return }
            print("error:\(error.localizedDescription)")
        }
    }
}
