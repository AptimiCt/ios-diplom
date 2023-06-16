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
    func numberOfRowsInSection() -> Int
    func getPostFor(_ indexPath: IndexPath) -> PostFS
    func getUser() -> User
    func getFriens() -> [User]
}
