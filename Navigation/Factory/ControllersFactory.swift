//
//  ControllersFactory.swift
//  Navigation
//
//  Created by Александр Востриков on 21.07.2022.
//

final class ControllerFactory: ControllersFactoryProtocol {
    
    private var userService: UserService
    
    init(userService: UserService) {
        self.userService = userService
        print("ControllerFactory создан")
    }
    func makeLoginController(with coordinator: LoginCoordinator) -> LoginViewControllerProtocol {
        let biometricService = LocalAuthorizationService()
        let loginView = LoginView(biometricType: biometricService.biometricType)
        let loginViewModel = LoginViewModel(firestore: FirestoreManager())
        let loginViewController = LoginViewController(loginView: loginView, viewModel: loginViewModel)
        loginView.delegate = loginViewController
        loginViewModel.coordinator = coordinator
        loginViewModel.userService = userService
        return loginViewController
    }
    func makeUpdateInfoProfile(with coordinator: LoginCoordinator, screenType: ScreenType) -> UpdateInfoProfileProtocol {
        let viewModel = UpdateInfoProfileViewModel(userService: userService, firestore: FirestoreManager())
        viewModel.coordinator = coordinator
        return UpdateInfoProfileController(viewModel: viewModel, screenType: screenType)
    }
    
    
    func makeFeedController(with coordinator: FeedCoordinator) ->  FeedViewControllerProtocol {
        let posts = Storage.posts
//        let viewModel = FeedViewModel(posts: posts)
        let viewModel = FeedViewModel(firestore: FirestoreManager())
        let feedViewController = FeedViewController(
            coordinator: coordinator,
            viewModel: viewModel,
            userService: userService
        )
        return feedViewController
    }
    func makeProfileController(with coordinator: ProfileCoordinator) -> ProfileViewControllerProtocol {
        let posts = Storage.posts
        let viewModel = ProfileViewModel(posts: posts)
        let profileViewController = ProfileViewController(
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
    deinit {
        print("ControllerFactory удален")
    }
}
