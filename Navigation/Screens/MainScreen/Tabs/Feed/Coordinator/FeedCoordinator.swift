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
        let feedTabBarIconSelected = UIImage(systemName: "house.fill")
        let feedTabBarIcon = UIImage(systemName: "house")
        let feedTabBarItem = UITabBarItem(title: Constants.navigationItemFeedTitle,
                                          image: feedTabBarIcon,
                                          selectedImage: feedTabBarIconSelected)
        navigationController.tabBarItem = feedTabBarItem
        let controller = ControllerFactory(navigationController: navigationController).makeUpdateInfoProfile(user: User(fullName: "Test", avatar: "", status: ""), coordinator: LoginCoordinator(navigationController: navigationController))
        guard let controller = controller.toPresent() else { return }
        navigationController.setViewControllers([controller], animated: false)
    }
}
