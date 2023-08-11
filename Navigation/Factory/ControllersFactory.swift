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
        Logger.standard.start(on: self)
    }
    func makeSplashController() -> SplashViewController {
        return SplashViewController()
    }
    func makeLoginController(with coordinator: LoginCoordinator) -> LoginViewControllerProtocol {
        let loginView = LoginView()
        let loginViewModel = LoginViewModel(userService: userService, firestore: FirestoreManager())
        let loginViewController = LoginViewController(loginView: loginView, viewModel: loginViewModel)
        loginView.delegate = loginViewController
        loginViewModel.coordinator = coordinator
        return loginViewController
    }
    func makeUpdateInfoProfile(with coordinator: UpdateInfoProfileCoordinator, screenType: ScreenType) -> UpdateInfoProfileProtocol {
        let viewModel = UpdateInfoProfileViewModel(userService: userService, firestore: FirestoreManager())
        viewModel.coordinator = coordinator
        return UpdateInfoProfileController(viewModel: viewModel, screenType: screenType)
    }

    func makePostDetailController(post: Post, index: Int) -> PostDetailViewControllerProtocol {
        let viewModel = PostDetailViewModel(userService: userService,
                                            firestore: FirestoreManager(),
                                            post: post,
                                            index: index
        )
        let postDetailController = PostDetailController(viewModel: viewModel)
        return postDetailController
    }
    
    func makeFeedController(with coordinator: FeedCoordinator) ->  FeedViewControllerProtocol {

        let viewModel = FeedViewModel(firestore: FirestoreManager(), coordinator: coordinator, userService: userService)
        let feedViewController = FeedViewController(viewModel: viewModel)
        return feedViewController
    }
    func makeProfileController(with coordinator: ProfileCoordinator) -> ProfileViewControllerProtocol {
        let viewModel = ProfileViewModel(firestore: FirestoreManager(), coordinator: coordinator, userService: userService)
        let profileViewController = ProfileViewController(viewModel: viewModel)
        return profileViewController
    }
    func makePhotosController() -> PhotosViewControllerProtocol {
        return PhotosViewController()
    }
    
    func makeFavoriteController(with coordinator: FavoriteCoordinator) -> FavoriteViewControllerProtocol {
        let viewModel = FavoritesViewModel(firestore: FirestoreManager(), coordinator: coordinator, userService: userService)
        let favoritesViewController = FavoritesViewController(viewModel: viewModel)
            
        return favoritesViewController
    }
    func makeFindFriendController(with coordinator: ProfileCoordinator) -> FindFriendViewControllerProtocol {
        let findFriendViewController = FindFriendViewController()
        let viewModel = FindFriendViewModel(firestore: FirestoreManager(), coordinator: coordinator, userService: userService)
        findFriendViewController.viewModel = viewModel
        return findFriendViewController
    }
    func makeAddPostController(with coordinator: ProfileCoordinator) -> AddPostViewControllerProtocol {
        let viewModel = AddPostViewModel(
            cellBuilder: PostCellBuilder(),
            firestore: FirestoreManager(),
            userService: userService
        )
        viewModel.coordinator = coordinator
        let addPostViewController = AddPostViewController(viewModel: viewModel)
        return addPostViewController
    }
    deinit {
        Logger.standard.remove(on: self)
    }
}
