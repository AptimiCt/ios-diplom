//
//
// FavoriteCoordinator.swift
// Navigation
//
// Created by Александр Востриков
//
    

import UIKit

final class FavoriteCoordinator: BaseCoordinator {
    
    override func start() {
        let controller = ControllerFactory(navigationController: navigationController).makeFavoriteController()
        guard let controller = controller.toPresent() else { return }
        navigationController.setViewControllers([controller], animated: false)
    }
}
