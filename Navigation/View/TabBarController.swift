//
//  TabBarController.swift
//  Navigation
//
//  Created by Александр Востриков on 21.07.2022.
//

import UIKit

class TabBarController: UITabBarController {
    
    private var feedViewController: UIViewController
    private var profileViewController: UIViewController
    private var favoriteViewController: UIViewController
    
    init() {
        self.feedViewController = ControllersFactory(navigationController: UINavigationController(), tab: .feed).controller
        self.profileViewController = ControllersFactory(navigationController: UINavigationController(), tab: .profile).controller
        self.favoriteViewController = ControllersFactory(navigationController: UINavigationController(), tab: .favorites).controller
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
            profileViewController,
            favoriteViewController
        ]
    }
    
    private func configTabBar(){
        tabBar.backgroundColor = .createColor(lightMode: .white, darkMode: .systemGray3)
    }
}
