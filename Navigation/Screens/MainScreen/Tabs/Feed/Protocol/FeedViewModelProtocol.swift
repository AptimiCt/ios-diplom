//
//
// FeedViewModelProtocol.swift
// Navigation
//
// Created by Александр Востриков
//

protocol FeedViewModelProtocol: AnyObject {
    
    var stateChanged: ((FeedViewModel.State) -> Void)? { get set }
    func changeState(completion: @escaping ()->())
    func numberOfRows() -> Int
    func numberOfSections() -> Int
    func getPostFor(_ index: Int) -> Post
    func cellType(at index: Int) -> CellType
    func addCoreData(_ index: Int, completion: @escaping BoolClosure)
    func getUser(for userUID: String) -> User
    func getFriends() -> [User]
    func updatePost(post: Post, for index: Int)
    func newPost(post: Post, for index: Int)
    func didSelectRow(at index: Int)
}
