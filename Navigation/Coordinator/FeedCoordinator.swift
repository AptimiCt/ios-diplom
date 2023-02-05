//
//  FeedCoordinator.swift
//  Navigation
//
//  Created by Александр Востриков on 22.07.2022.
//

import Foundation
import UIKit
import StorageService

class FeedCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    
    private var navController: UINavigationController
    
    init(navController: UINavigationController) {
        self.navController = navController
    }
    
    func showPostVC(post: Post) {
        let postViewController = PostViewController(post: post, coordinator: self)
        navController.pushViewController(postViewController, animated: true)
    }
    func showFileVC() {
        let filesViewController = FilesViewController()
        navController.pushViewController(filesViewController, animated: true)
    }
    
    func showInfo(){
        let infoVC = InfoViewController(coordinator: self)
        navController.present(infoVC, animated: true, completion: nil)
    }
    
    func showAlert(in controller: UIViewController){
        let title = Constants.alertButtonActionTitle
        let message = Constants.alertButtonActionMessage
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: Constants.alertButtonActionCancel, style: .destructive) { _ in
            print(Constants.alertButtonActionCancelPressed)
        }
        let actionOk = UIAlertAction(title: Constants.alertButtonActionOk, style: .default) { _ in
            print(Constants.alertButtonActionOkPressed)
        }
        alert.addAction(actionCancel)
        alert.addAction(actionOk)
        controller.present(alert, animated: true, completion: nil)
    }
}
