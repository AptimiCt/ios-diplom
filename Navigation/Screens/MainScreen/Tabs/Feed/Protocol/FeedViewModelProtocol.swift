//
//
// FeedViewModelProtocol.swift
// Navigation
//
// Created by Александр Востриков
//

import UIKit

protocol FeedViewModelProtocol: AnyObject {
    
    var stateChanged: ((FeedViewModel.State) -> Void)? { get set }
    func changeState(completion: @escaping ()->())
    func numberOfRows() -> Int
    func getPostFor(_ indexPath: IndexPath) -> PostFS
    func updateViews(postUID: String)
    func showDetail(post: PostFS)
    func getUser(for userUID: String) -> User
    func getFriens() -> [User]
}
