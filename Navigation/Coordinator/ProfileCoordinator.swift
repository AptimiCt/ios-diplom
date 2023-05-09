//
//
// ProfileCoordinator.swift
// Navigation
//
// Created by Александр Востриков
//
    

import UIKit

final class ProfileCoordinator: BaseCoordinator, OutputCoordinator {
    
    var finishFlow: ((User?) -> Void)?
    
    private let user: User
    
    init(user: User, navigationController: UINavigationController) {
        self.user = user
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        runProfile()
    }
    
    private func runProfile() {
        let posts = Storage.posts
        let viewModel = ProfileViewModel(posts: posts)
        let userService = CurrentUserService()
        let profileViewController = ProfileViewController(
            loginName: user.fullName,
            userService: userService,
            coordinator: self,
            viewModel: viewModel
        )
        navigationController.isNavigationBarHidden = true
        navigationController.setViewControllers([profileViewController], animated: false)
    }
    func showPhotosVC(){
        let nvc = PhotosViewController()
        navigationController.isNavigationBarHidden = false
        navigationController.pushViewController(nvc, animated: true)
    }
}
