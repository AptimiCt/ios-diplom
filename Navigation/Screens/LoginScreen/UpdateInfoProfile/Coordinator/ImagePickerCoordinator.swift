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
    
    var finishFlow: (UIImage?) -> Void = { _ in }
    var finishPicker: VoidClosure = { }
    
    init(router: Router) {
        self.router = router
        super.init()
        Logger.standart.start(on: self)
    }
    
    override func start() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.presentationController?.delegate = self
        router.toPresent()?.presentedViewController?.present(imagePickerController, animated: true)
    }
    
    deinit {
        Logger.standart.remove(on: self)
    }
}
extension ImagePickerCoordinator: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            finishFlow(image)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        finishFlow(nil)
    }
}
extension ImagePickerCoordinator: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        finishPicker()
    }
}
