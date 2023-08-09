//
//  Cells.swift
//  Navigation
//
//  Created by Александр Востриков on 09.02.2022.
//

import UIKit

struct Cells {
    static let cellForProfileTableViewCell = String(describing: ProfileTableViewCell.self)
    static let cellForPostTableViewCell = String(describing: PostTableViewCell.self)
    static let cellForPostTableViewCellWithoutImage = String(describing: PostTableViewCellWithoutImage.self)
    static let cellForPostFavorites = String(describing: FavoritesViewController.self)
    static let cellForSectionNew = String(describing: PhotosTableViewCell.self)
    static let cellForSection = String(describing: PhotosTableViewCellNew.self)
    static let cellForSectionToCollection = String(describing: FriendsViewCell.self)
    static let cellForFriendsCollectionViewCell = String(describing: FriendsCollectionViewCell.self)
    static let cellForCollection = String(describing: PhotosCollectionViewCell.self)
    static let cellForFindFriend = String(describing: FindFriendCell.self)
    static let cellForBodyImageViewCell = String(describing: BodyImageViewCell.self)
}
