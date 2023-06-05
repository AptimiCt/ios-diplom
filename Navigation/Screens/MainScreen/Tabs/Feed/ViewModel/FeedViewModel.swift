//
//
// FeedViewModel.swift
// Navigation
//
// Created by Александр Востриков
//
    
import UIKit
import StorageService



final class FeedViewModel: FeedViewModelProtocol {
//    var posts: [StorageService.Post]
    
    enum State {
        case initial
        case loaded(FeedViewModelProtocol)
        case error
    }
    private let firestore: DatabeseManagerProtocol
    internal var posts: [PostFS] = []
    
    var stateChanged: ((FeedViewModel.State) -> Void)?
    
    init(firestore: DatabeseManagerProtocol){
        stateChanged?(.initial)
        self.firestore = firestore
    }
    
    func changeState(completion: @escaping () -> ()) {
        firestore.fetchAllPosts(uid: "yLIesutMQmXTxtANvhjb8cBljmy1") { result in
            switch result {
                case .success(let posts):
//                    print("posts:\(posts)")
                    self.posts = posts
                    self.stateChanged?(.loaded(self))
                    completion()
                case .failure(let error):
                    print("error:\(error)")
            }
        }
        completion()
    }
    
    func numberOfRowsInSection() -> Int {
        posts.count
    }
    
    func getPostFor(_ indexPath: IndexPath) -> PostFS {
        posts[indexPath.row]
    }
}
