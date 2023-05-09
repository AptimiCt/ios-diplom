//
//  FeedCoordinator.swift
//  Navigation
//
//  Created by Александр Востриков on 22.07.2022.
//

import Foundation
import UIKit
import StorageService

class FeedCoordinator: BaseCoordinator {
    
    override func start(){
        let feedTabBarIcon = UIImage(named: "Home")
        let feedTabBarItem = UITabBarItem(title: "Fav", image: feedTabBarIcon, selectedImage: nil)
        navigationController.tabBarItem = feedTabBarItem
        let filesViewController = FilesViewController()
        navigationController.setViewControllers([filesViewController], animated: false)
    }
}
