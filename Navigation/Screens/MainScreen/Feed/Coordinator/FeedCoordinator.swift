//
//  FeedCoordinator.swift
//  Navigation
//
//  Created by Александр Востриков on 22.07.2022.
//

import UIKit

class FeedCoordinator: BaseCoordinator {
    
    private let router: Router
    private var factory: FeedControllerFactoryProtocol
    
    init(router: Router, factory: FeedControllerFactoryProtocol) {
        self.router = router
        self.factory = factory
    }
    
    override func start(){
        let feedTabBarIcon = UIImage(systemName: "doc")
        let feedTabBarItem = UITabBarItem(title: "Files", image: feedTabBarIcon, selectedImage: nil)
        guard let navigationController = router.toPresent() as? UINavigationController else { return }
        navigationController.tabBarItem = feedTabBarItem
        let filesViewController = FilesViewController()
        router.setRootModule(filesViewController, hideBar: true)
    }
}
