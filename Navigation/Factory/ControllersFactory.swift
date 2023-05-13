//
//  ControllersFactory.swift
//  Navigation
//
//  Created by Александр Востриков on 21.07.2022.
//

import UIKit

final class ControllerFactory: AuthControllerFactoryProtocol,
                               ProfileControllerFactoryProtocol,
                               FavoriteControllerFactoryProtocol,
                               FeedControllerFactoryProtocol
{
    let navigationController: UINavigationController

    init(navigationController: UINavigationController){
        self.navigationController = navigationController
    }
    
    func makeLoginController(with coordinator: LoginCoordinator) -> LoginViewControllerProtocol {
        let biometricService = LocalAuthorizationService()
        let loginView = LoginView(biometricType: biometricService.biometricType)
        let loginViewModel = LoginViewModel()
        let loginViewController = LoginViewController(loginView: loginView, viewModel: loginViewModel)
        loginView.delegate = loginViewController
        loginViewModel.coordinator = coordinator
        navigationController.navigationBar.isHidden = true
        navigationController.tabBarItem = UITabBarItem(title: Constants.tabBarItemLoginVCTitle,
                                                   image: UIImage(systemName: "person.crop.circle.fill"),
                                                   tag: 1)
        return loginViewController
    }
    func makeUpdateInfoProfile(user: User, coordinator: LoginCoordinator) -> UpdateInfoProfileProtocol {
        let viewModel = UpdateInfoProfileViewModel(user: user)
        viewModel.coordinator = coordinator
        return UpdateInfoProfileController(viewModel: viewModel)
    }
    func makeProfileController(with user: User, and coordinator: ProfileCoordinator) -> ProfileViewControllerProtocol {
        let posts = Storage.posts
        let viewModel = ProfileViewModel(posts: posts)
        let userService = userServiceScheme()
        let profileViewController = ProfileViewController(
            loginName: user.fullName,
            userService: userService,
            coordinator: coordinator,
            viewModel: viewModel
        )
        return profileViewController
    }
    func makePhotosController() -> PhotosViewControllerProtocol {
        return PhotosViewController()
    }
    
    func makeFavoriteController() -> FavoriteViewControllerProtocol {
        let favoritesNavigationController = FavoritesViewController()
        navigationController.setViewControllers([favoritesNavigationController], animated: true)
        return favoritesNavigationController
    }
    func makeFeedController(with user: User, and coordinator: ProfileCoordinator) -> ProfileViewControllerProtocol {
        let posts = Storage.posts
        let viewModel = ProfileViewModel(posts: posts)
        let userService = userServiceScheme()
        let profileViewController = ProfileViewController(
            loginName: user.fullName,
            userService: userService,
            coordinator: coordinator,
            viewModel: viewModel
        )
        return profileViewController
    }
}
private extension ControllerFactory {
    //    Выбора UserService в зависимости от схемы
        func userServiceScheme() -> UserService {
            #if DEBUG
            let userService = TestUserService()
            #else
            let userService = CurrentUserService()
            #endif
            return userService
        }
}
