//
//  ControllersFactory.swift
//  Navigation
//
//  Created by Александр Востриков on 21.07.2022.
//

final class ControllerFactory: AuthControllerFactoryProtocol,
                               ProfileControllerFactoryProtocol,
                               FavoriteControllerFactoryProtocol,
                               FeedControllerFactoryProtocol
{

    func makeLoginController(with coordinator: LoginCoordinator) -> LoginViewControllerProtocol {
        let biometricService = LocalAuthorizationService()
        let loginView = LoginView(biometricType: biometricService.biometricType)
        let loginViewModel = LoginViewModel()
        let loginViewController = LoginViewController(loginView: loginView, viewModel: loginViewModel)
        loginView.delegate = loginViewController
        loginViewModel.coordinator = coordinator
        return loginViewController
    }
    func makeUpdateInfoProfile(user: User, coordinator: LoginCoordinator) -> UpdateInfoProfileProtocol {
        let viewModel = UpdateInfoProfileViewModel(user: user)
        viewModel.coordinator = coordinator
        return UpdateInfoProfileController(viewModel: viewModel)
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
        return favoritesNavigationController
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
