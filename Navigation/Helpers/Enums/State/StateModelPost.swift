//
//
// StateModelPost.swift
// Navigation
//
// Created by Александр Востриков
//
    

enum StateModelPost {
    case initial
    case success(PostData)
    
    struct PostData {
        let uidUser: String
        var profilePicture: String?
        var fullName: String
        var createdDate: String
        let uidPost: String
        var body: String
        var postImage: String?
        var likes: Int
        var isLiked: Bool
        var views:Int
    }
}
