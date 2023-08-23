//
//
// Post.swift
// Navigation
//
// Created by Александр Востриков
//
    
import Foundation

struct Post: Codable {
    let userUid: String
    var postUid: String
    let title: String?
    let body: String
    var imageUrl: String?
    var postImageFilename: String {
        return postUid + "_post"
    }
    let likes: [String]
    let views: Int
    let createdDate: Date
    let updateDate: Date
    let comments: [String]
    
    init(userUid: String,
         postUid: String = "",
         title: String? = "",
         body: String,
         imageUrl: String? = nil,
         likes: [String] = [],
         views: Int = 0,
         createdDate: Date = Date(),
         updateDate: Date = Date(),
         comments: [String] = []
    ) {
        self.userUid = userUid
        self.postUid = postUid
        self.title = title
        self.body = body
        self.imageUrl = imageUrl
        self.likes = likes
        self.views = views
        self.createdDate = createdDate
        self.updateDate = updateDate
        self.comments = comments
    }
}
