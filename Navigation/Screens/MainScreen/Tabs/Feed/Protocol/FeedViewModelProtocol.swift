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
    func numberOfSections() -> Int
    func getPostFor(_ indexPath: IndexPath) -> Post
    func cellType(at indexPath: IndexPath) -> CellType
    func getUser(for userUID: String) -> User
    func getFriends() -> [User]
    func updatePost(post: Post, for index: Int)
    func didSelectRow(at indexPath: IndexPath)
}
