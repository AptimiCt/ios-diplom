//
//
// PostView.swift
// Navigation
//
// Created by Александр Востриков
//


import UIKit

final class PostView: UIView {
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .large)
        activity.color = .createColor(lightMode: .black, darkMode: .white)
        activity.toAutoLayout()
        return activity
    }()
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .createColor(lightMode: .black, darkMode: .white)
        label.numberOfLines = 1
        return label
    }()
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .createColor(lightMode: .secondaryLabel, darkMode: .white)
        label.numberOfLines = 1
        return label
    }()
    private lazy var fotoImageView: UIImageView = {
        let image = UIImageView()
        image.toAutoLayout()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
        return image
    }()
    private lazy var postImageView: UIImageView = {
        let image = UIImageView()
        image.toAutoLayout()
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        return image
    }()
    private lazy var bodyLabel: UILabel = {
        let description = UILabel()
        description.toAutoLayout()
        description.font = .systemFont(ofSize: 14)
        description.textColor = .createColor(lightMode: .systemGray, darkMode: .white)
        description.numberOfLines = 0
        return description
    }()
    private lazy var likesButton: UIButton = {
        var config = UIButton.Configuration.borderedTinted()
        config.contentInsets = .init(top: 5, leading: 8, bottom: 5, trailing: 8)
        config.imagePadding = 8
        config.cornerStyle = .capsule
        
        let button = UIButton()
        button.toAutoLayout()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.addTarget(self, action: #selector(likesButtonTapped), for: .touchUpInside)
        button.configuration = config
        return button
    }()
    private lazy var viewsImageView: UIButton = {
        var config = UIButton.Configuration.plain()
        config.contentInsets = .init(top: 5, leading: 8, bottom: 5, trailing: 8)
        config.imagePadding = 8
        config.cornerStyle = .capsule
        
        let button = UIButton()
        button.toAutoLayout()
        button.setImage(UIImage(systemName: "eyes"), for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.tintColor = .createColor(lightMode: .black, darkMode: .white)
        button.isUserInteractionEnabled = false
        button.configuration = config
        return button
    }()
    private lazy var footerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 24
        stackView.toAutoLayout()
        return stackView
    }()
    private let constantHeightPostImageView = (Constants.screenWeight) / 2.5
    private lazy var heightAnchorPostImageView: NSLayoutConstraint = postImageView.heightAnchor.constraint(equalToConstant: constantHeightPostImageView)
    
    weak var delegate: PostViewDelegate?
    var stateView: StatePostView = .initial {
        didSet {
            setNeedsLayout()
        }
    }
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        switch stateView {
            case .initial:
                activityIndicatorOn()
            case .success(let postData):
                configure(post: postData)
                activityIndicatorOff()
        }
        configureConstraints()
    }
}
@objc private extension PostView {
    func likesButtonTapped(){
        delegate?.likesButtonTapped()
    }
}
private extension PostView {
    func activityIndicatorOff() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
    }
    func activityIndicatorOn() {
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
    }
    
    func configure(post: StatePostView.PostData) {
        authorLabel.text = post.fullName
        if let profileImage = post.profilePicture {
            if let postPictureUrl = URL(string: profileImage) {
                fotoImageView.sd_setImage(with: postPictureUrl)
            }
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
        likesButton.setTitle("\(post.likes)", for: .normal)
        viewsImageView.setTitle("\(post.views)", for: .normal)
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
    func setupViews(){
        self.backgroundColor = .createColor(lightMode: .white, darkMode: .systemGray3)
        self.toAutoLayout()
        footerStackView.addArrangedSubview(likesButton)
        footerStackView.addArrangedSubview(viewsImageView)
        
        self.addSubviews(
            fotoImageView,
            authorLabel,
            dateLabel,
            bodyLabel,
            postImageView,
            footerStackView,
            activityIndicator
        )
    }
    //Установка констраинтов
    func configureConstraints() {
        let constrains = [
            self.widthAnchor.constraint(equalToConstant: Constants.screenWeight),
            fotoImageView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            fotoImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 18),
            fotoImageView.heightAnchor.constraint(equalToConstant: 40),
            fotoImageView.widthAnchor.constraint(equalTo: fotoImageView.heightAnchor),
            fotoImageView.trailingAnchor.constraint(equalTo: authorLabel.leadingAnchor, constant: -16),
            fotoImageView.bottomAnchor.constraint(equalTo: postImageView.topAnchor, constant: -12),
            
            authorLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18),
            authorLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            authorLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor),
            
            dateLabel.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
            dateLabel.bottomAnchor.constraint(lessThanOrEqualTo: bodyLabel.topAnchor, constant: 4),
            
            postImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            postImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            postImageView.bottomAnchor.constraint(equalTo: bodyLabel.topAnchor, constant: -16),
            
            bodyLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            bodyLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            bodyLabel.bottomAnchor.constraint(equalTo: footerStackView.topAnchor, constant: -16),
            
            footerStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 16),
            footerStackView.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -30),
            footerStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constrains)
        heightAnchorPostImageView.isActive = true
    }
}
