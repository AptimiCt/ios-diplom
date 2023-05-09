//
//  TabBarController.swift
//  Navigation
//
//  Created by Александр Востриков on 21.07.2022.
//

import UIKit

class TabBarController: UITabBarController {

    var onFeedSelect: ((UINavigationController) -> ())?
    var onProfileSelect: ((UINavigationController) -> ())?
    var onFavoriteSelect: ((UINavigationController) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setControllers()
        configTabBar()
        delegate = self
    }
}
extension TabBarController {
    func firstLoad() {
        if let viewControllers {
            for (index, controller) in viewControllers.enumerated() {
                guard let controller = controller as? UINavigationController else { return }
                switch index {
                    case 0:
                        onFeedSelect?(controller)
                    case 1:
                        onProfileSelect?(controller)
                    case 2:
                        onFavoriteSelect?(controller)
                    default:
                        break
                }
            }
        }
    }
}
private extension TabBarController {
    func setControllers() {
        viewControllers = [
            UINavigationController(),
            UINavigationController(),
            UINavigationController()
        ]
    }
    func configTabBar(){
        tabBar.backgroundColor = .createColor(lightMode: .white, darkMode: .systemGray3)
    }
}
extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
      guard let controller = viewControllers?[selectedIndex] as? UINavigationController else { return }
        switch selectedIndex {
            case 0:
                onFeedSelect?(controller)
            case 1:
                onProfileSelect?(controller)
            case 2:
                onFavoriteSelect?(controller)
            default:
                print("Неизвестная вкладка")
        }
    }
}
