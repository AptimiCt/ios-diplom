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
    case profile
    case favorites
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
                
                let profileCoordinator = LoginCoordinator(navController: controller)
                let profileViewController = Self.createProfileViewController(loginName: Constants.testUserServiceFullName, userService: TestUserService(), coordinator: profileCoordinator)
                controller.setViewControllers([profileViewController], animated: true)
            case .profile:
                let loginCoordinator = LoginCoordinator(navController: controller)
                let currentLoginFactory = CurrentLoginFactory()
                let loginViewController = LoginViewController(coordinator: loginCoordinator, delegate: currentLoginFactory.create())
                controller.setViewControllers([loginViewController], animated: true)
            case .favorites:
                let favoritesNavigationController = FavoritesViewController()
                controller.setViewControllers([favoritesNavigationController], animated: true)
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
