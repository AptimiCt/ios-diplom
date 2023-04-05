//
//  Storage.swift
//  Navigation
//
//  Created by Александр Востриков on 24.01.2022.
//

import Foundation
import StorageService

struct Storage {
    static let posts: [Post] = [
        Post(id: 1, author: ~K.Storage.Keys.firstPostAuthor.rawValue, description: ~K.Storage.Keys.firstPostDescription.rawValue, image: "karib", likes: 1000, views: 10000000),
        Post(id: 2, author: ~K.Storage.Keys.secondPostAuthor.rawValue, description: ~K.Storage.Keys.secondPostDescription.rawValue, image: "bars", likes: 1, views: 21),
        Post(id: 3, author: ~K.Storage.Keys.thirdPostAuthor.rawValue, description: ~K.Storage.Keys.thirdPostDescription.rawValue, image: "baikal", likes: 0, views: 0),
        Post(id: 4, author: ~K.Storage.Keys.fourthPostAuthor.rawValue, description: ~K.Storage.Keys.fourthPostDescription.rawValue, image: "salut", likes: 2, views: 52)
    ]
    
}
