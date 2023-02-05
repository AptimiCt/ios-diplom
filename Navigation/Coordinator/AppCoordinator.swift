//
//  AppCoordinator.swift
//  Navigation
//
//  Created by Александр Востриков on 19.06.2022.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseAuth

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
}

final class AppCoordinator: Coordinator {
    
    let window: UIWindow
    let rootViewController: UIViewController
    var childCoordinators: [Coordinator] = []
    
    init(window: UIWindow) {
        self.window = window
        self.rootViewController = ControllersFactory.createTabBarController()
    }
    
    func start() {
        FirebaseApp.configure()
        let appConfiguration = AppConfiguration.allCases.randomElement()
        NetworkManager.request(for: appConfiguration)
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}
