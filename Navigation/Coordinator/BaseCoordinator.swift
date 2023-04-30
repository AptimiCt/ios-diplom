//
//
// BaseCoordinator.swift
// Navigation
//
// Created by Александр Востриков
//
    

import Foundation

class BaseCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    
    func start() {}
    
    func addCoordinator(_ coordinator: Coordinator) {
        guard !childCoordinators.contains(where: { $0 === coordinator }) else { return }
        childCoordinators.append(coordinator)
    }
    func removeCoordinator(_ coordinator: Coordinator?) {
        guard childCoordinators.isEmpty == false, let coordinator else { return }
        if let coordinator = coordinator as? BaseCoordinator, !coordinator.childCoordinators.isEmpty {
            coordinator.childCoordinators
                .filter { $0 !== coordinator }
                .forEach { coordinator.removeCoordinator($0) }
        }
        for (index, element) in childCoordinators.enumerated() where element === coordinator {
            childCoordinators.remove(at: index)
            break
        }
    }
}
