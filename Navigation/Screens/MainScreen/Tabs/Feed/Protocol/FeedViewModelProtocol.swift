//
//
// FeedViewModelProtocol.swift
// Navigation
//
// Created by Александр Востриков
//
    
import StorageService

protocol FeedViewModelProtocol: AnyObject {
    
    var posts: [PostFS] { get set }
    var stateChanged: ((FeedViewModel.State) -> Void)? { get set }
    func changeState(completion: @escaping ()->())
    func numberOfRowsInSection() -> Int
    func getPostFor(_ indexPath: IndexPath) -> PostFS
}
