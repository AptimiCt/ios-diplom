//
//  Cells.swift
//  Navigation
//
//  Created by Александр Востриков on 09.02.2022.
//

import UIKit

struct Cells {
    static let cellForPostProfile = String(describing: ProfileViewController.self)
    static let cellForPostFeed = String(describing: FeedViewController.self)
    static let cellForPostFavorites = String(describing: FavoritesViewController.self)
    static let cellForSection = String(describing: PhotosTableViewCell.self)
    static let cellForSectionToCollection = String(describing: FriendsViewCell.self)
    static let cellForFriendsCollectionViewCell = String(describing: FriendsCollectionViewCell.self)
    static let cellForCollection = String(describing: PhotosCollectionViewCell.self)
}
