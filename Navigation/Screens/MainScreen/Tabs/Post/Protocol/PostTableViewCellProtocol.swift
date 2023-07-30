//
//
// PostTableViewCellProtocol.swift
// Navigation
//
// Created by Александр Востриков
//
    

protocol PostTableViewCellProtocol {
    
    var delegate: PostTableViewCellDelegate? { get set }
    func configure(post: PostFS, with user: User)
}
