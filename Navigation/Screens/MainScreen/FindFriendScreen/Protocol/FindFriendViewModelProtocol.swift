//
//
// FindFriendViewModelProtocol.swift
// Navigation
//
// Created by Александр Востриков
//

import UIKit

protocol FindFriendViewModelProtocol: AnyObject {
    func searchUsers(query: String, completion: @escaping VoidClosure)
    func numberOfRows() -> Int
    func getResultFor(_ indexPath: IndexPath) -> SearchResult
    func addFriend(for indexPath: IndexPath, completion: @escaping VoidClosure)
    func removeFromFriend(for indexPath: IndexPath, completion: @escaping VoidClosure)
}
