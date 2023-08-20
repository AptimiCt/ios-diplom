//
//
// FavoritesViewModel.swift
// Navigation
//
// Created by Александр Востриков
//

import Foundation

final class FavoritesViewModel: FavoritesViewModelProtocol {
    
    enum State {
        case initial
        case loaded(FavoritesViewModelProtocol)
        case error
    }
    private let firestore: DatabeseManagerProtocol
    private let coordinator: FavoriteCoordinator
    
    private var posts: [Post] = []
    private var users: [User] = []
    var stateChanged: ((FavoritesViewModel.State) -> Void)?
    
    init(firestore: DatabeseManagerProtocol,
         coordinator: FavoriteCoordinator
    ) {
        stateChanged?(.initial)
        self.firestore = firestore
        self.coordinator = coordinator
        Logger.standard.start(on: self)
    }
    
    func changeState(completion: @escaping VoidClosure) {
        CoreDataManager.dataManager.fetch(predicate: nil) { [weak self] result in
            guard let self else { return }
            stateChanged?(.initial)
            switch result {
                case .success(let posts):
                    self.posts = posts.map { self.mappingPost(postDataModel: $0) }
                    self.users = posts.map { self.mappingUser(postDataModel: $0) }
                case .failure(let error):
                    print(error.localizedDescription)
            }
            self.stateChanged?(.loaded(self))
            completion()
        }
    }
    
    func numberOfRows() -> Int {
        posts.count
    }
    func getPostFor(_ index: Int) -> Post {
        posts[index]
    }
    func deletePost(at index: Int, completion: @escaping BoolClosure) {
        
        let newPosts = self.posts
        let deletedPost = getPostFor(index)
        self.posts.remove(at: index)
        
        let predicate = NSPredicate(format: "postUid == %@", deletedPost.postUid)
        CoreDataManager.dataManager.delete(predicate: predicate) { [weak self] result in
            guard let self else { completion(false); return }
            switch result {
                case .success:
                    completion(true)
                case .failure(let error):
                    self.posts = newPosts
                    print(error.localizedDescription)
                    completion(false)
            }
        }
    }
    func getUser(at index: Int) -> User {
        users[index]
    }
    func cellType(at index: Int) -> CellType {
        guard let _ = getPostFor(index).imageUrl else { return .postCell }
        return .postWithImageCell
    }
    func didSelectRow(at index: Int) {
        let post = posts[index]
        let user = users[index]
        coordinator.showDetail(post: post, user: user, index: index)
    }
    func filterFavorites(findText: String = "", isFiltered: Bool = false) {
        let predicate = isFiltered ? NSPredicate(format: "body CONTAINS[c] %@", findText) : nil
        CoreDataManager.dataManager.fetch(predicate: predicate) { [weak self] result in
            guard let self else { return }
            stateChanged?(.initial)
            switch result {
                case .success(let posts):
                    self.posts = posts.map { self.mappingPost(postDataModel: $0) }
                    self.users = posts.map { self.mappingUser(postDataModel: $0) }
                case .failure(let error):
                    print(error.localizedDescription)
            }
            stateChanged?(.loaded(self))
        }
    }
    func filterFavorites() {
        filterFavorites(findText: "", isFiltered: false)
    }
    deinit {
        Logger.standard.remove(on: self)
    }
}
private extension FavoritesViewModel {
    func mappingPost(postDataModel: PostCoreData) -> Post {
        
        return Post(userUid: postDataModel.userUid ?? "",
                    postUid: postDataModel.postUid ?? "",
                    title: postDataModel.title,
                    body: postDataModel.body ?? "",
                    imageUrl: postDataModel.imageUrl,
                    likes: postDataModel.likes ?? [],
                    views: Int(postDataModel.views),
                    createdDate: postDataModel.createdDate ?? Date(),
                    updateDate: postDataModel.updateDate ?? Date())
    }
    func mappingUser(postDataModel: PostCoreData) -> User {
        
        let uid = postDataModel.userUid ?? ""
        let name = postDataModel.userName ?? ""
        let surname = postDataModel.userSurname ?? ""
        let profilePictureUrl = postDataModel.userProfileImage
        
        return User(uid: uid, name: name, surname: surname, profilePicture: profilePictureUrl)
    }
}
