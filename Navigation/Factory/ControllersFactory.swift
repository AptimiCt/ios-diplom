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
                let profileCoordinator = ProfileCoordinator(user: User(fullName: Constants.testUserServiceFullName, avatar: "", status: ""), navigationController: controller)
                let profileViewController = Self.createProfileViewController(loginName: Constants.testUserServiceFullName, userService: TestUserService(), coordinator: profileCoordinator)
                controller.setViewControllers([profileViewController], animated: true)
            case .profile:
                let biometricService = LocalAuthorizationService()
                let loginView = LoginView(
                    biometricType: biometricService.biometricType)
                let loginViewModel = LoginViewModel()
                let loginViewController = LoginViewController(loginView: loginView, viewModel: loginViewModel)
                loginView.delegate = loginViewController
                controller.navigationBar.isHidden = true
                controller.tabBarItem = UITabBarItem(title: Constants.tabBarItemLoginVCTitle,
                                                           image: UIImage(systemName: "person.crop.circle.fill"),
                                                           tag: 1)
                controller.setViewControllers([loginViewController], animated: true)
            case .favorites:
                let favoritesNavigationController = FavoritesViewController()
                controller.setViewControllers([favoritesNavigationController], animated: true)
        }
    }
    
    static func createProfileViewController(loginName: String, userService: UserService, coordinator: ProfileCoordinator) -> UIViewController {
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
