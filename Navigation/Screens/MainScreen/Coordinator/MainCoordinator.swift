//
//
// TabBarCoordinator.swift
// Navigation
//
// Created by Александр Востриков
//


import UIKit

final class MainCoordinator: BaseCoordinator, OutputCoordinator {
    
    var finishFlow: ((User?) -> Void)?
    
    private let router: Router
    
    private var user: User?
    private var tabBarController: TabBarController
    
    init(
        router: Router,
        tabBarVC: TabBarController,
        with user: User
    ) {
        self.tabBarController = tabBarVC
        self.user = user
        self.router = router
    }
    override func start() {
        tabBarController.onFeedSelect = runFeedSelect()
        tabBarController.onProfileSelect = runProfileSelect()
        tabBarController.onFavoriteSelect = runFavoriteSelect()
        tabBarController.firstLoad()
    }
}

private extension MainCoordinator {
    
    func runFeedSelect() -> ((UINavigationController) -> ()) {
        return { [unowned self] navController in
            if navController.viewControllers.isEmpty == true {
                let router = RouterImpl(rootController: navController)
                let feedCoordinator = FeedCoordinator(router: router, factory: ControllerFactory())
                self.addCoordinator(feedCoordinator)
                feedCoordinator.start()
            }
        }
    }
    
    func runProfileSelect() -> ((UINavigationController) -> ()) {
        return { [unowned self] navController in
            if navController.viewControllers.isEmpty == true {
                guard let user else { return }
                let router = RouterImpl(rootController: navController)
                let profileCoordinator = ProfileCoordinator(user: user, router: router, factory: ControllerFactory())
                profileCoordinator.finishFlow = { [weak self, weak profileCoordinator] user in
                    if user == nil {
                        self?.user = nil
                    }
                    self?.removeCoordinator(profileCoordinator)
                    self?.finishFlow?(user)
                }
                addCoordinator(profileCoordinator)
                profileCoordinator.start()
            }
        }
    }
    func runFavoriteSelect() -> ((UINavigationController) -> ()) {
        return { [unowned self] navController in
            if navController.viewControllers.isEmpty == true {
                let router = RouterImpl(rootController: navController)
                let favoriteCoordinator = FavoriteCoordinator(router: router, factory: ControllerFactory())
                addCoordinator(favoriteCoordinator)
                favoriteCoordinator.start()
            }
        }
    }
}
