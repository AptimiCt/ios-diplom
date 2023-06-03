//
//
// SplashViewController.swift
// Navigation
//
// Created by Александр Востриков
//
    
import UIKit

final class SplashViewController: UIViewController {
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.toAutoLayout()
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
}

private extension SplashViewController {
    func configureView() {
        view.backgroundColor = .createColor(lightMode: .white, darkMode: .systemGray3)
        view.addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: Constants.heightForLogoImageView),
            logoImageView.widthAnchor.constraint(equalToConstant: Constants.widthForLogoImageView),
        ])
    }
}
