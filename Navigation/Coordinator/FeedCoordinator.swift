//
//  FeedCoordinator.swift
//  Navigation
//
//  Created by Александр Востриков on 22.07.2022.
//

import Foundation
import UIKit
import StorageService

class FeedCoordinator: BaseCoordinator {
    
    func showPostVC(post: Post) {
        let postViewController = PostViewController(post: post, coordinator: self)
        navigationController.pushViewController(postViewController, animated: true)
    }
    func showFileVC() {
        let filesViewController = FilesViewController()
        navigationController.pushViewController(filesViewController, animated: true)
    }
    
    func showInfo(){
        
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
