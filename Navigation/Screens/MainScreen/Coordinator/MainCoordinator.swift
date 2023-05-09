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
    
    private var user: User?
    private var tabBarController: TabBarController
    
    init(
        navigationController: UINavigationController,
        tabBarVC: TabBarController,
        with user: User
    ) {
        self.tabBarController = tabBarVC
        self.user = user
        super.init(navigationController: navigationController)
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
                let feedCoordinator = FeedCoordinator(navigationController: navController)
                self.addCoordinator(feedCoordinator)
                feedCoordinator.start()
            }
        }
    }
    
    func runProfileSelect() -> ((UINavigationController) -> ()) {
        return { [unowned self] navController in
            if navController.viewControllers.isEmpty == true {
                guard let user else { return }
                let profileCoordinator = ProfileCoordinator(user: user, navigationController: navController)
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
                let favoriteCoordinator = FavoriteCoordinator(navigationController: navController)
                addCoordinator(favoriteCoordinator)
                favoriteCoordinator.start()
            }
        }
    }
}
