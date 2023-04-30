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

final class AppCoordinator: BaseCoordinator {
    
    let window: UIWindow
    let rootViewController: UIViewController
    let localNotificationService = LocalNotificationsService()
    
    init(window: UIWindow) {
        self.window = window
        self.rootViewController = ControllersFactory.createTabBarController()
    }
    
    override func start() {
        FirebaseApp.configure()
        //let appConfiguration = AppConfiguration.allCases.randomElement()
        localNotificationService.registeForLatestUpdatesIfPossible()
        //NetworkManager.request(for: appConfiguration)
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}
