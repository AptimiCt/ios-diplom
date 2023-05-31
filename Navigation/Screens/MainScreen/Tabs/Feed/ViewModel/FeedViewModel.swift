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
        self.posts = [PostFS(userUid: "sdfkjsdhkjfksd", title: "Foo Bar", body: ~K.Storage.Keys.firstPostDescription.rawValue, imageUrl: "karib", likes: 10, views: 100, frends: [], createdDate: Date(), updateDate: Date()),
                      PostFS(userUid: "sdfkjsdhkjfksd", title: "Foo Bar", body: ~K.Storage.Keys.firstPostDescription.rawValue, imageUrl: "karib", likes: 10, views: 100, frends: [], createdDate: Date(), updateDate: Date())]
        completion()
    }
    
    func numberOfRowsInSection() -> Int {
        posts.count
    }
    
    func getPostFor(_ indexPath: IndexPath) -> PostFS {
        posts[indexPath.row]
    }
}
