//
//
// ProfileViewModelProtocol.swift
// Navigation
//
// Created by Александр Востриков
//
    

protocol ProfileViewModelProtocol: AnyObject {

    var stateChanged: ((ProfileViewModel.State) -> Void)? { get set }
    func changeState(completion: @escaping ()->())
    func numberOfRows() -> Int
    func getPostFor(_ index: Int) -> PostFS
    func addCoreData(_ index: Int, completion: @escaping BoolClosure)
    func getUser() -> User
    func showPhotosVC()
    func showFindFriendVC()
    func finishFlow()
}
