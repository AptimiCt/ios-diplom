//
//
// PostDetailController.swift
// Navigation
//
// Created by Александр Востриков
//
    

import UIKit

final class PostDetailController: UIViewController, PostDetailViewControllerProtocol {
    
    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .large)
        activity.color = .createColor(lightMode: .black, darkMode: .white)
        activity.toAutoLayout()
        return activity
    }()
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .createColor(lightMode: .black, darkMode: .white)
        label.numberOfLines = 1
        return label
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .createColor(lightMode: .secondaryLabel, darkMode: .white)
        label.numberOfLines = 1
        return label
    }()
    private let fotoImageView: UIImageView = {
        let image = UIImageView()
        image.toAutoLayout()
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
        return image
    }()
    private let postImageView: UIImageView = {
        let image = UIImageView()
        image.toAutoLayout()
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        return image
    }()
    private let bodyLabel: UILabel = {
        let description = UILabel()
        description.toAutoLayout()
        description.font = .systemFont(ofSize: 14)
        description.textColor = .createColor(lightMode: .systemGray, darkMode: .white)
        description.numberOfLines = 0
        return description
    }()
    private let likesLabel: UILabel = {
        let likes = UILabel()
        likes.toAutoLayout()
        likes.font = .systemFont(ofSize: 16)
        likes.numberOfLines = 0
        likes.textColor = .createColor(lightMode: .black, darkMode: .white)
        return likes
    }()
    private lazy var likesButton: CustomButton = {
        let likesImage = CustomButton()
        likesImage.toAutoLayout()
        likesImage.setImage(UIImage(systemName: "heart"), for: .normal)
        likesImage.tintColor = .createColor(lightMode: .black, darkMode: .white)
        likesImage.addTarget(self, action: #selector(likesButtonTapped), for: .touchUpInside)
        return likesImage
    }()
    private let viewsLabel: UILabel = {
        let views = UILabel()
        views.toAutoLayout()
        views.font = .systemFont(ofSize: 16)
        views.numberOfLines = 0
        views.textColor = .createColor(lightMode: .black, darkMode: .white)
        return views
    }()
    private let viewsImageView: UIImageView = {
        let image = UIImageView()
        image.toAutoLayout()
        image.contentMode = .scaleAspectFit
        image.tintColor = .createColor(lightMode: .black, darkMode: .white)
        return image
    }()
    private let footerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 24
        stackView.toAutoLayout()
        return stackView
    }()
    private let likesStackView: UIStackView = {
        let likesStackView = UIStackView()
        likesStackView.axis = .horizontal
        likesStackView.spacing = 8
        likesStackView.toAutoLayout()
        return likesStackView
    }()
    private let viewsStackView: UIStackView = {
        let viewsStackView = UIStackView()
        viewsStackView.axis = .horizontal
        viewsStackView.spacing = 8
        viewsStackView.toAutoLayout()
        return viewsStackView
    }()
    private let constantHeightPostImageView = (Constants.screenWeight) / 2.5
    private lazy var heightAnchorPostImageView: NSLayoutConstraint = postImageView.heightAnchor.constraint(equalToConstant: constantHeightPostImageView)

    //MARK: - property

    var viewModel: PostDetailViewModelProtocol
    //MARK: - init
    init(viewModel: PostDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.setupViews()
        self.configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - override funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        viewModel.setupView()
        
    }
    private func setupViewModel(){
        viewModel.stateChanged = { [weak self] state in
            guard let self else { return }
            switch state {
                case .initial:
                    self.activityIndicator(animate: true)
                case .success(let post):
                    configure(post: post)
                    self.activityIndicator(animate: false)
            }
        }
    }
    deinit {
        print("PostDetailController удален")
    }
}
@objc private extension PostDetailController {
    func addPostToFavorite() {
        
    }
    func likesButtonTapped(){
        viewModel.likesButtonTapped()
    }
}
//MARK: - private funcs in extension
private extension PostDetailController {
    func configure(post: StateModelPost.PostData) {
        authorLabel.text = post.fullName
        viewsImageView.image = UIImage(systemName: "message")
        if let postPictireUrl = URL(string: post.profilePicture) {
            fotoImageView.sd_setImage(with: postPictireUrl)
        }
        dateLabel.text = post.createdDate
        bodyLabel.text = post.body
        if post.isLiked {
            likesButton.tintColor = .systemRed
            likesButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            likesButton.tintColor = .createColor(lightMode: .black, darkMode: .white)
            likesButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        likesLabel.text = "\(post.likes)"
        viewsLabel.text = "\(post.views)"
        if let postImage = post.postImage {
            if let postImageUrl = URL(string: postImage) {
                postImageView.isHidden = false
                postImageView.sd_setImage(with: postImageUrl)
            }
        } else {
            postImageView.isHidden = true
            heightAnchorPostImageView.constant = 0
        }
    }
    func activityIndicator(animate: Bool){
        activityIndicator.isHidden = !animate
        DispatchQueue.main.async {
            animate ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
        }
    }
    func makeActivityIndicatorView() -> UIActivityIndicatorView {
        let activity = UIActivityIndicatorView(style: .large)
        activity.color = .createColor(lightMode: .black, darkMode: .white)
        activity.toAutoLayout()
        return activity
    }
}
//MARK: - private funcs in extension configure Views
private extension PostDetailController {
    func setupViews(){
        view.backgroundColor = .createColor(lightMode: .white, darkMode: .systemGray3)
        
        scrollView.toAutoLayout()
        contentView.toAutoLayout()
        
        view.addSubviews(scrollView, activityIndicator)
        scrollView.addSubview(contentView)
        scrollView.keyboardDismissMode = .interactive
        
        footerStackView.addArrangedSubview(likesStackView)
        footerStackView.addArrangedSubview(viewsStackView)
        
        likesStackView.addArrangedSubview(likesButton)
        likesStackView.addArrangedSubview(likesLabel)
        viewsStackView.addArrangedSubview(viewsImageView)
        viewsStackView.addArrangedSubview(viewsLabel)
        
        contentView.addSubviews(
            fotoImageView,
            authorLabel,
            dateLabel,
            bodyLabel,
            postImageView,
            footerStackView
        )
    }
    //Установка констраинтов
    func configureConstraints(){
        let constrains = [
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            fotoImageView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            fotoImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 18),
            fotoImageView.heightAnchor.constraint(equalToConstant: 40),
            fotoImageView.widthAnchor.constraint(equalTo: fotoImageView.heightAnchor),
            fotoImageView.trailingAnchor.constraint(equalTo: authorLabel.leadingAnchor, constant: -16),
            fotoImageView.bottomAnchor.constraint(equalTo: postImageView.topAnchor, constant: -12),
            
            authorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            authorLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor),
            
            dateLabel.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
            dateLabel.bottomAnchor.constraint(lessThanOrEqualTo: bodyLabel.topAnchor, constant: 4),
            
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            postImageView.bottomAnchor.constraint(equalTo: bodyLabel.topAnchor, constant: -16),
            
            bodyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bodyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            bodyLabel.bottomAnchor.constraint(equalTo: footerStackView.topAnchor, constant: -16),
            
            footerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 16),
            footerStackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -30),
            footerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constrains)
        heightAnchorPostImageView.isActive = true
    }
}
