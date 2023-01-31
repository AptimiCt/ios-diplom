//
//  SceneDelegate.swift
//  Navigation
//
//  Created by Александр Востриков on 21.11.2021.
//

import UIKit
import StorageService
import FirebaseCore
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
//    var appConfiguration: AppConfiguration
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        FirebaseApp.configure()
        let appConfiguration = AppConfiguration.allCases.randomElement()
        NetworkManager.request(for: appConfiguration)
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let post = Post(author: Constants.post, description: Constants.post, image: "bars", likes: 1, views: 1)
        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = .systemGray6
        
        
        let feedViewController = FeedViewController(post: post)
        let loginViewController = LoginViewController()
        let profileVC = FavoritesViewController()
        let mapVC = MapViewController()
        let currentLoginFactory = CurrentLoginFactory()
        loginViewController.delegate = currentLoginFactory.create()
        
        let feedNavigationController = UINavigationController(rootViewController: feedViewController)
        let profileNavigationController = UINavigationController(rootViewController: loginViewController)
        
        let favoritesNavigationController = UINavigationController(rootViewController: profileVC)
        
        tabBarController.viewControllers = [feedNavigationController,profileNavigationController,favoritesNavigationController, mapVC]
        tabBarController.selectedIndex = 1
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        self.window = window
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        do {
            try FirebaseAuth.Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

