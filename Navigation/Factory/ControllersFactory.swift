//
//  ViewControllersFactory.swift
//  Navigation
//
//  Created by Александр Востриков on 21.07.2022.
//

import UIKit
import StorageService

enum Tab {
    case feed
    case login
    case favorites
    case map
}

final class ControllersFactory {
    
    let controller: UINavigationController
    
    private let tab: Tab
    
    init(navigationController: UINavigationController, tab: Tab){
        self.controller = navigationController
        self.tab = tab
        createTabBarViewController()
    }
    
    private func createTabBarViewController(){
        switch tab {
            case .feed:
                let post = Post(id: 1, author: Constants.post, description: Constants.post, image: "bars", likes: 1, views: 1)
                let feedCoordinator = FeedCoordinator(navController: controller)
                let feedViewController = FeedViewController(post: post, coordinator: feedCoordinator)
                controller.setViewControllers([feedViewController], animated: true)
            case .login:
                let loginCoordinator = LoginCoordinator(navController: controller)
                let currentLoginFactory = CurrentLoginFactory()
                let loginViewController = LoginViewController(coordinator: loginCoordinator, delegate: currentLoginFactory.create())
                controller.setViewControllers([loginViewController], animated: true)
            case .favorites:
                let favoritesNavigationController = FavoritesViewController()
                controller.setViewControllers([favoritesNavigationController], animated: true)
            case .map:
                let mapVC = MapViewController()
                controller.setViewControllers([mapVC], animated: true)
        }
    }
    
    static func createProfileViewController(loginName: String, userService: UserService, coordinator: LoginCoordinator) -> UIViewController {
        let posts = Storage.posts
        let viewModel = ProfileViewModel(posts: posts)
        let profileViewController = ProfileViewController(
            loginName: loginName,
            userService: userService,
            coordinator: coordinator,
            viewModel: viewModel
        )
        return profileViewController
    }
    
    static func createTabBarController() -> TabBarController {
        return TabBarController()
    }
}
