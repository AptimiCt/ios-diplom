//
//  FeedViewController.swift
//  Navigation
//
//  Created by Александр Востриков on 28.11.2021.
//

import UIKit
import StorageService

class FeedViewController: UIViewController {
    
    //MARK: - vars
    private var post: Post?
    private let tabBarItemLocal = UITabBarItem(title: Constants.navigationItemFeedTitle,
                                       image: UIImage(systemName: "f.circle.fill"),
                                       tag: 0)
    
    private let buttonToPostFirst = CustomButton(title: Constants.firstButton, titleColor: .white)
    private let buttonToPostSecond = CustomButton(title: Constants.files, titleColor: .white)
    
    private let checkWordButton: CustomButton = {
        let checkButton = CustomButton(title: Constants.checkWord, titleColor: .white)
        checkButton.setTitleColor(UIColor.systemPurple, for: .highlighted)
        checkButton.backgroundColor = .systemBlue
        checkButton.layer.cornerRadius = 10
        checkButton.toAutoLayout()
        return checkButton
    }()
    
    private let wordTextField: CustomTextField = {
        let textField = CustomTextField(font: .systemFont(ofSize: 18, weight: .bold), placeholder: Constants.wordTextField)
        textField.textAlignment = .center
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.backgroundColor = .lightText
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true
        textField.toAutoLayout()
        return textField
    }()
    
    private lazy var labelCheck: UILabel = {
        let label = UILabel()
        label.alpha = 0
        label.backgroundColor = .systemIndigo
        label.layer.cornerRadius = 10
        label.isUserInteractionEnabled = true
        label.textAlignment = .center
        label.clipsToBounds = true
        label.toAutoLayout()
        return label
    }()
    
    private let stackView = UIStackView()
    
    //MARK: - init
    init(){
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem = tabBarItemLocal
    }
    
    init(post: Post){
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem = tabBarItemLocal
        self.post = post
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - override
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupButtons()
        setupStack()
        setupConstraints()
        buttonsAction()
    }
    
    //MARK: - private func
    private func setupView() {
        view.backgroundColor = .systemGray3
        self.navigationItem.title = Constants.navigationItemFeedTitle
    }
    
    private func setupButtons(){
        buttonToPostFirst.toAutoLayout()
        buttonToPostSecond.toAutoLayout()
        buttonToPostFirst.backgroundColor = .red
        buttonToPostFirst.layer.cornerRadius = 10
        
        buttonToPostSecond.backgroundColor = .blue
        buttonToPostSecond.layer.cornerRadius = 10
    }
    
    private func setupStack(){
        stackView.toAutoLayout()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.addArrangedSubview(buttonToPostFirst)
        stackView.addArrangedSubview(buttonToPostSecond)
        view.addSubviews(stackView, wordTextField, checkWordButton, labelCheck)
    }
    
    private func setupConstraints(){
        let constraints = [
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.topAnchor.constraint(equalTo: checkWordButton.bottomAnchor, constant: 15),
            
            checkWordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            checkWordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            checkWordButton.topAnchor.constraint(equalTo: wordTextField.bottomAnchor, constant: 15),
            
            wordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            wordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            wordTextField.heightAnchor.constraint(equalToConstant: 34),
            labelCheck.bottomAnchor.constraint(equalTo: checkWordButton.topAnchor, constant: -5),
            labelCheck.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            labelCheck.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            labelCheck.heightAnchor.constraint(equalToConstant: 70),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func labelShow(text: String, color: UIColor){
        labelCheck.text = text
        labelCheck.textColor = color
        UIView.animateKeyframes(withDuration: 3, delay: 0) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.3) {
                self.labelCheck.alpha = 1
            }
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 1) {
                self.labelCheck.alpha = 0
            }
        }
    }
    
    private func buttonsAction(){
        buttonToPostFirst.action = { [weak self] in
            guard let post = self?.post else { return }
            let postViewController = PostViewController(post: post)
            self?.navigationController?.pushViewController(postViewController, animated: true)
        }
        buttonToPostSecond.action = { [weak self] in
            let filesViewController = FilesViewController()
            self?.navigationController?.pushViewController(filesViewController, animated: true)
            
        }
        checkWordButton.action = { [weak self] in
            guard let word = self?.wordTextField.text, !(word.isEmpty),let post = self?.post else { return }
            let check = post.checker(word: word)
            check ? self?.labelShow(text: Constants.checkWordButtonTrue, color: .green) : self?.labelShow(text: Constants.checkWordButtonFalse, color: .red)
        }
    }
}
