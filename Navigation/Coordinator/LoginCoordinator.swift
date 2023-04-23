//
//  LoginCoordinator.swift
//  Navigation
//
//  Created by Александр Востриков on 22.07.2022.
//

import Foundation
import UIKit
import StorageService

class LoginCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    
    private var navController: UINavigationController
    
    init(navController: UINavigationController) {
        self.navController = navController
    }
    
    func showProfileVC(loginName: String) {
        let userService = userServiceScheme()
        let profileViewController = ControllersFactory.createProfileViewController(loginName: loginName, userService: userService, coordinator: self)
        navController.pushViewController(profileViewController, animated: true)
    }
    
    func showPhotosVC(){
        let nvc = PhotosViewController()
        navController.pushViewController(nvc, animated: true)
    }
    func showAlertController(in controller: UIViewController, message: String) {
        AlertController.defaultController.showAlert(in: controller,
                                                    message: message)
    }
//    Выбора UserService в зависимости от схемы
    private func userServiceScheme() -> UserService {
        #if DEBUG
        let userService = TestUserService()
        #else
        let userService = CurrentUserService()
        #endif
        return userService
    }
}
