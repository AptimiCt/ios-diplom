//
//
// PostDetailViewModelProtocol.swift
// Navigation
//
// Created by Александр Востриков
//
    

protocol PostDetailViewModelProtocol {
    var stateChanged: ((StateModelPost) -> Void)? { get set }
    func setupView()
    func likesButtonTapped()
}
