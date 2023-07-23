//
//
// ImagePickerCoordinator.swift
// Navigation
//
// Created by Александр Востриков
//
import UIKit
final class ImagePickerCoordinator: BaseCoordinator {
   
    private let router: Router
    private let factory: AuthControllerFactoryProtocol
    
    var onFinishPicking: (UIImage) -> Void = { _ in }
    
    init(router: Router, factory: AuthControllerFactoryProtocol) {
        self.router = router
        self.factory = factory
        super.init()
        Logger.standart.start(on: self)
    }
    
    override func start() {
//        let controller = factory.makeLoginController(with: self)
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        router.present(imagePickerController, animated: true)
    }
    
    deinit {
        Logger.standart.remove(on: self)
    }
}
extension ImagePickerCoordinator: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            onFinishPicking(image)
        }
        
    }
}