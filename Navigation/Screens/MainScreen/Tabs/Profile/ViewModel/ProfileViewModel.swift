//
//  ProfileViewModel.swift
//  Navigation
//
//  Created by Александр Востриков on 06.01.2023.
//

import Foundation
import StorageService

protocol ProfileViewModelProtocol: AnyObject {

    var stateChanged: ((ProfileViewModel.State) -> Void)? { get set }
    func changeState(completion: @escaping ()->())
    func numberOfRowsInSection() -> Int
    func getPostFor(_ indexPath: IndexPath) -> Post
}

final class ProfileViewModel: ProfileViewModelProtocol {
    
    enum State {
        case initial
        case loaded(ProfileViewModelProtocol)
        case error
    }
    
    var posts: [Post] {
        didSet{
            stateChanged?(.loaded(self))
        }
    }
    
    var stateChanged: ((ProfileViewModel.State) -> Void)?

    init(posts: [Post]){
        stateChanged?(.initial)
        self.posts = posts
    }
    
    func numberOfRowsInSection() -> Int {
        posts.count
    }
    func getPostFor(_ indexPath: IndexPath) -> Post {
        posts[indexPath.row]
    }
    
    func changeState(completion: @escaping ()->()) {
        self.posts = Storage.posts
        completion()
    }
}
