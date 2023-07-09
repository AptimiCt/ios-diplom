//
//
// FindFriendViewModel.swift
// Navigation
//
// Created by Александр Востриков
//

import UIKit

final class FindFriendViewModel: FindFriendViewModelProtocol {
    
    private let firestore: DatabeseManagerProtocol
    private let coordinator: ProfileCoordinator
    private let userService: UserService
    
    private var users = [User]()
    private var filtredUsers = [SearchResult]()
    private var hasFetched = false
    
    init(firestore: DatabeseManagerProtocol, coordinator: ProfileCoordinator, userService: UserService) {
        self.firestore = firestore
        self.coordinator = coordinator
        self.userService = userService
    }
    
    func numberOfRows() -> Int {
        filtredUsers.count
    }
    func getFriens() -> [User] {
        return userService.friends
    }
    
    func getResultFor(_ indexPath: IndexPath) -> SearchResult {
        filtredUsers[indexPath.row]
    }
    func searchUsers(query: String, completion: @escaping VoidClosure)  {
        filtredUsers.removeAll()
        if hasFetched {
            filterUsers(with: query, completion: completion)
        }
        else {
            getAllUsers() { [weak self] result in
                switch result {
                    case .success(let usersCollection):
                        self?.hasFetched = true
                        self?.users = usersCollection
                        self?.filterUsers(with: query, completion: completion)
                    case .failure(let error):
                        let inputData = UIAlertControllerInputData(message: error.localizedDescription, buttons: [.init(title: "UIAC.ok".localized)])
                        self?.coordinator.showAlert(inputData: inputData)
                        completion()
                }
            }
        }
    }
    func addFriend(for indexPath: IndexPath, completion: @escaping VoidClosure) {
        let friend = filtredUsers[indexPath.row]
        
        firestore.addFriend(userId: userService.getUser().uid, friendId: friend.uid) { [weak self] error in
            guard let self else { return }
            if error == nil {
                let newFriend = SearchResult(uid: friend.uid,
                                             name: friend.name,
                                             profileImageUrl: friend.profileImageUrl,
                                             isFriend: true)
                self.filtredUsers[indexPath.row] = newFriend
                let user = userService.getUser()
                var friends = user.friends
                friends.append(friend.uid)
                user.friends = friends
                userService.set(user: user)
                userService.fetchFriends {
                    completion()
                }
            } else {
                let inputData = UIAlertControllerInputData(message: error?.localizedDescription, buttons: [.init(title: "UIAC.ok".localized)])
                coordinator.showAlert(inputData: inputData)
                completion()
            }
        }
    }
    func removeFromFriend(for indexPath: IndexPath, completion: @escaping VoidClosure) {
        let friend = filtredUsers[indexPath.row]
        
        firestore.removeFromFriend(userId: userService.getUser().uid, friendId: friend.uid) { [weak self] error in
            guard let self else { return }
            if error == nil {
                let newFriend = SearchResult(uid: friend.uid,
                                             name: friend.name,
                                             profileImageUrl: friend.profileImageUrl,
                                             isFriend: false)
                self.filtredUsers[indexPath.row] = newFriend
                let user = userService.getUser()
                var friends = user.friends
                friends.removeAll(where: { $0 == friend.uid } )
                user.friends = friends
                userService.set(user: user)
                userService.fetchFriends {
                    completion()
                }
            } else {
                let inputData = UIAlertControllerInputData(message: error?.localizedDescription, buttons: [.init(title: "UIAC.ok".localized)])
                coordinator.showAlert(inputData: inputData)
                completion()
            }
        }
    }
}
private extension FindFriendViewModel {
    func getAllUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        firestore.fetchAllUsers(without: userService.getUser().uid) { result in
            completion(result)
        }
    }
    func filterUsers(with searchText: String, completion: @escaping () -> Void) {
        
        let filtredUsers: [SearchResult] = users.filter({
            let name = $0.getFullName().lowercased()
            let lowerSearchText = searchText.lowercased()
            return name.contains(lowerSearchText)
        }).compactMap({
            let isFriend = self.getFriens().contains($0)
            return SearchResult(uid: $0.uid,
                                name: $0.getFullName(),
                                profileImageUrl: $0.profilePictureUrl,
                                isFriend: isFriend)
        })
        
        self.filtredUsers = filtredUsers
        completion()
    }
}
