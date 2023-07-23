//
//  ProfileViewModel.swift
//  Navigation
//
//  Created by Александр Востриков on 06.01.2023.
//


final class ProfileViewModel: ProfileViewModelProtocol {
    
    enum State {
        case initial
        case loaded(ProfileViewModelProtocol)
        case error
    }
    
    private let firestore: DatabeseManagerProtocol
    private let coordinator: ProfileCoordinator
    private let userService: UserService
    
    private var posts: [PostFS] = []
    
    var stateChanged: ((ProfileViewModel.State) -> Void)?

    init(firestore: DatabeseManagerProtocol, coordinator: ProfileCoordinator, userService: UserService) {
        stateChanged?(.initial)
        self.firestore = firestore
        self.coordinator = coordinator
        self.userService = userService
    }
    
    func changeState(completion: @escaping VoidClosure) {
        let userId = getUser().uid
        firestore.fetchAllPosts(uid: userId) { result in
            switch result {
                case .success(let posts):
                    self.posts = posts.sorted(by: { $0.createdDate > $1.createdDate })
                    self.stateChanged?(.loaded(self))
                case .failure(let error):
                    print("error posts:\(error)")
            }
            completion()
        }
    }
    
    func numberOfRows() -> Int {
        posts.count
    }
    func getPostFor(_ index: Int) -> PostFS {
        posts[index]
    }
    func getUser() -> User {
        userService.getUser()
    }
    func addCoreData(_ index: Int, completion: @escaping BoolClosure) {
        let post = getPostFor(index)
        CoreDataManager.dataManager.create(post: post) { result in
            switch result {
                case .success(_):
                    completion(true)
                case .failure(let error):
                    completion(false)
                    print("error create:\(error.localizedDescription)")
            }
        }
        completion(true)
    }
    func showPhotosVC() {
        coordinator.showPhotosVC()
    }
    func showEditProfileVC() {
        coordinator.showEditProfileVC()
    }
    func showFindFriendVC() {
        coordinator.showFindFriendVC()
    }
    func showAddPostVC() {
        print(#function)
    }
    func showAddPhoto() {
        print(#function)
    }
    func finishFlow() {
        coordinator.finishFlow?(nil)
    }
}
