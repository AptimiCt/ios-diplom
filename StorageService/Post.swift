//
//  Post.swift
//  Navigation
//
//  Created by Александр Востриков on 06.12.2021.
//

import Foundation

public struct Post {
    
    public let word = "пароль"
    public let id: Int
    public let author: String
    public let description: String
    public let image: String
    public let likes: Int
    public let views: Int
    
    public init(id: Int, author: String, description: String,
         image: String, likes: Int, views: Int){
        self.id = id
        self.author = author
        self.description = description
        self.image = image
        self.likes = likes
        self.views = views
    }
    
    public func checker(word: String) -> Bool {
        word == self.word ? true : false
    }
}
