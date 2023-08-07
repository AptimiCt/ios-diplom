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
        super.init()
        Logger.standard.start(on: self)
    }
    
    override func start(){
        runFeed()
    }
    func showDetail(post: Post, index: Int) {
        let controller = factory.makePostDetailController(post: post, index: index)
        router.push(controller, hideBottomBar: true, hideBar: false)
    }
    deinit {
        Logger.standard.remove(on: self)
    }
}

private extension FeedCoordinator {
    func runFeed() {
        let feedTabBarIconSelected = UIImage(systemName: "house.fill")
        let feedTabBarIcon = UIImage(systemName: "house")
        let feedTabBarItem = UITabBarItem(title: Constants.navigationItemFeedTitle,
                                          image: feedTabBarIcon,
                                          selectedImage: feedTabBarIconSelected)
        guard let navigationController = router.toPresent() as? UINavigationController else { return }
        navigationController.tabBarItem = feedTabBarItem
        
        let controller = factory.makeFeedController(with: self)
        router.setRootModule(controller)
    }
}
