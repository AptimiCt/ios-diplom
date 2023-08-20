//
//
// FavoritesViewModelProtocol.swift
// Navigation
//
// Created by Александр Востриков
//


protocol FavoritesViewModelProtocol: AnyObject {
    
    var stateChanged: ((FavoritesViewModel.State) -> Void)? { get set }
    func changeState(completion: @escaping VoidClosure)
    func numberOfRows() -> Int
    func getPostFor(_ index: Int) -> Post
    func deletePost(at index: Int, completion: @escaping BoolClosure)
    func getUser(at index: Int) -> User
    func cellType(at index: Int) -> CellType
    func didSelectRow(at index: Int)
    func filterFavorites(findText: String, isFiltered: Bool)
    func filterFavorites()
}
