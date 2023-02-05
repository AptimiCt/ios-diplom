//
//  TabBarController.swift
//  Navigation
//
//  Created by Александр Востриков on 21.07.2022.
//

import UIKit

class TabBarController: UITabBarController {
    
    private var feedViewController: UIViewController
    private var loginViewController: UIViewController
    private var favoriteViewController: UIViewController
    private var mapViewController: UIViewController
    
    init() {
        self.feedViewController = ControllersFactory(navigationController: UINavigationController(), tab: .feed).controller
        self.loginViewController = ControllersFactory(navigationController: UINavigationController(), tab: .login).controller
        self.favoriteViewController = ControllersFactory(navigationController: UINavigationController(), tab: .favorites).controller
        self.mapViewController = ControllersFactory(navigationController: UINavigationController(), tab: .map).controller
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setControllers()
        configTabBar()
    }
    
    private func setControllers() {
        viewControllers = [
            feedViewController,
            loginViewController,
            favoriteViewController,
            mapViewController
        ]
        selectedIndex = 1
    }
    
    private func configTabBar(){
        tabBar.backgroundColor = .createColor(lightMode: .white, darkMode: .systemGray3)
    }
}
