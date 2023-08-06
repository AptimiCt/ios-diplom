//
//
// AddPostViewModelNew.swift
// Navigation
//
// Created by Александр Востриков
//


import UIKit

final class AddPostViewModel {
    
    let title = "Добавить запись"
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
        return cells[indexPath.row]
    }
    
    func tappedDone() {
        guard let bodyText = bodyCellViewModel?.bodyText else { return }
        let user = userService.getUser()
        let post = Post(userUid: user.uid, body: bodyText, imageUrl: nil, likes: [], views: 0, createdDate: Date(), updateDate: Date())
        FirestoreManager().addNewPost(post: post) { error in
            guard let error else { return }
            print("error:\(error.localizedDescription)")
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
            case .bodyImageView(let BodyImageViewCellViewModel):
                BodyImageViewCellViewModel.update(text)
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
}

private extension AddPostViewModel {
    func updateImage(with image: UIImage) -> BodyImageViewCellViewModel {
        let postImageCellViewModel = cellBuilder.makeBodyImageViewCellViewModel(.image)
        postImageCellViewModel.update(image)
        return postImageCellViewModel
    }
    
    func setupCells() {
        bodyCellViewModel = cellBuilder.makeBodyImageViewCellViewModel(.text)
        guard let bodyCellViewModel = bodyCellViewModel else { return }
        cells = [.bodyImageView(bodyCellViewModel)]
    }
}
