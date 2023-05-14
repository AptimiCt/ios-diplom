//
//  FeedCoordinator.swift
//  Navigation
//
//  Created by Александр Востриков on 22.07.2022.
//

import UIKit
//import StorageService

class FeedCoordinator: BaseCoordinator {
    
    private let router: Router
    private var factory: AuthControllerFactoryProtocol
    
    init(router: Router, factory: AuthControllerFactoryProtocol) {
        self.router = router
        self.factory = factory
    }
    
    override func start(){
        let feedTabBarIconSelected = UIImage(systemName: "house.fill")
        let feedTabBarIcon = UIImage(systemName: "house")
        let feedTabBarItem = UITabBarItem(title: Constants.navigationItemFeedTitle,
                                          image: feedTabBarIcon,
                                          selectedImage: feedTabBarIconSelected)
        guard let navigationController = router.toPresent() as? UINavigationController else { return }
        navigationController.tabBarItem = feedTabBarItem
        
        let controller = factory.makeUpdateInfoProfile(user: User(fullName: "Test", avatar: "", status: ""), coordinator: LoginCoordinator(router: router, factory: factory))
        router.setRootModule(controller)
    }
}
