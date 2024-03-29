//
//
// PostDetailViewModelWithCommentsProtocol.swift
// Navigation
//
// Created by Александр Востриков
//
    

protocol PostDetailViewModelWithCommentsProtocol {
    var stateChanged: ((StateModelPostWithComments) -> Void)? { get set }
    func changeState(completion: @escaping VoidClosure)
    func getPost() -> StatePostView.PostData
    func getComment(at index: Int) -> CommentDataCell
    func addComment(with text: String, completion: @escaping BoolClosure)
    func numberOfRows() -> Int
    func setupView()
    func likesButtonTapped()
}
