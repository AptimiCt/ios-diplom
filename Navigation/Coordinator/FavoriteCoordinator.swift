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
        let favoritesController = FavoritesViewController()
        navigationController.setViewControllers([favoritesController], animated: false)
    }
}
