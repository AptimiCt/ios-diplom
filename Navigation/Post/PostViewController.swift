//
//  PostViewController.swift
//  Navigation
//
//  Created by Александр Востриков on 06.12.2021.
//

import UIKit
import StorageService

final class PostViewController: UIViewController {
    
    private var post: Post?
    
    weak var coordinator: FeedCoordinator?
    
    init(post: Post, coordinator: FeedCoordinator) {
        self.post = post
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        let leftButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                             target: self,
                                             action: #selector(openInfoVC))
        view.backgroundColor = .systemBlue
        navigationItem.title = post?.author
        navigationItem.setRightBarButton(leftButtonItem, animated: true)
        navigationController?.navigationBar.tintColor = .createColor(lightMode: .black, darkMode: .white)
    }
    
    @objc private func openInfoVC(){
        coordinator?.showInfo()
    }
}
