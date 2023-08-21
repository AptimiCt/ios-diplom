//
//
// ProfileViewModelProtocol.swift
// Navigation
//
// Created by Александр Востриков
//
    
import UIKit

protocol ProfileViewModelProtocol: AnyObject {

    var stateChanged: ((ProfileViewModel.State) -> Void)? { get set }
    func changeState(completion: @escaping ()->())
    func numberOfRows() -> Int
    func getPostFor(_ index: Int) -> Post
    func cellType(at index: Int) -> CellType
    func addCoreData(_ index: Int, completion: @escaping BoolClosure)
    func getUser() -> User
    func getPhotos() -> [UIImage]
    func newPost(post: Post, for index: Int)
    func updatePost(post: Post, for index: Int)
    func didSelectRow(at index: Int)
    func likesButtonTapped(at index: Int)
    func showPhotosVC()
    func showFindFriendVC()
    func showEditProfileVC()
    func showAddPostVC()
    func showAddPhoto()
    func finishFlow()
}
