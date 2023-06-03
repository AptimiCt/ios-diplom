//
//
// PostTableViewCellFS.swift
// Navigation
//
// Created by Александр Востриков
//
    

import UIKit
import iOSIntPackage

class PostTableViewCellFS: UITableViewCell {
    
    
    
//    var post: PostFS? {
//        didSet{
//            guard let author = post?.title else { return }
//            authorLabel.text = author
//            jobLabel.text = "Ingener"
//            viewsImageView.image = UIImage(systemName: "message")
//            fotoImageView.image = UIImage(named: "defaultProfilePicture")
//            bodyLabel.text = post?.body
//            guard let likes = post?.likes else { return }
//            likesLabel.text = "\(likes.count)"
//            guard let views = post?.views else { return }
//            viewsLabel.text = "\(views)"
//            guard let image = post?.imageUrl else { return }
//            guard let sourceImage = UIImage(named: image) else { return }
//            postImageView.image = sourceImage
//        }
//    }
    
//    private var isLiked: Bool {
//        print(post)
//        print("\n")
//        guard let likes = post?.likes else { return true }
//        print("\n")
//        print("likes.contains(yLIesutMQmXTxtANvhjb8cBljmy1):\(likes.contains("yLIesutMQmXTxtANvhjb8cBljmy1"))")
//        return likes.contains("yLIesutMQmXTxtANvhjb8cBljmy1") ? true : false
//    }
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .createColor(lightMode: .black, darkMode: .white)
        label.numberOfLines = 1
        return label
    }()
    
    private let jobLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .createColor(lightMode: .secondaryLabel, darkMode: .white)
        label.numberOfLines = 0
        return label
    }()
    
    private let fotoImageView: UIImageView = {
        let image = UIImageView()
        image.toAutoLayout()
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .black
        image.layer.cornerRadius = 30
        image.clipsToBounds = true
        return image
    }()
    
    private let postImageView: UIImageView = {
        let image = UIImageView()
        image.toAutoLayout()
        image.contentMode = .scaleToFill
        image.backgroundColor = .black
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        return image
    }()
    
    private let bodyLabel: UILabel = {
        let description = UILabel()
        description.toAutoLayout()
        description.font = .systemFont(ofSize: 14)
        description.textColor = .createColor(lightMode: .systemGray, darkMode: .white)
        description.numberOfLines = 4
        return description
    }()
    private lazy var readMore: CustomButton = {
        let readMore = CustomButton()
        readMore.toAutoLayout()
        readMore.setTitle("Показать полностью...", for: .normal)
        readMore.setTitleColor(.systemBlue, for: .normal)
        readMore.setTitleColor(.systemGray, for: .highlighted)
        readMore.addTarget(self, action: #selector(readMoreButtonTapped), for: .touchUpInside)
        return readMore
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        configureConstraints()
        guard reuseIdentifier == Cells.cellForPostFeed else { return }
//        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(addPostToFavorite))
//                doubleTap.numberOfTapsRequired = 2
//                self.addGestureRecognizer(doubleTap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func vizualizeAdd(color: UIColor) {
        contentView.backgroundColor = color
        UIView.animate(withDuration: 1, delay: 0) {
            self.contentView.backgroundColor = .createColor(lightMode: .white, darkMode: .systemGray3)
        }
    }
    
    @objc private func addPostToFavorite() {
        let post = PostFS(userUid: "yLIesutMQmXTxtANvhjb8cBljmy1", title: "Test Sistem", body: "Какая замечательная история", imageUrl: "baikal", likes: [], views: 47, frends: [], createdDate: Date(), updateDate: Date())
        print("error:")
        FirestoreManager().addNewPost(post: post) { error in
            print("error:\(error)")
        }
//        guard let post else { return }
//        CoreDataManager.dataManager.create(post: post) { [weak self] result in
//            switch result {
//                case .success(_):
//                    self?.vizualizeAdd(color: .systemGreen)
//                case .failure(let error):
//                    self?.vizualizeAdd(color: .systemRed)
//                    print(error.localizedDescription)
//            }
//        }
    }
    @objc private func likesButtonTapped(){
//        if isLiked {
//            likesButton.tintColor = .systemRed
//            likesButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//        } else {
//            likesButton.tintColor = .createColor(lightMode: .black, darkMode: .white)
//            likesButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//        }
    }
    @objc private func readMoreButtonTapped(){
        bodyLabel.numberOfLines = 0
        let post = PostFS(userUid: "yLIesutMQmXTxtANvhjb8cBljmy1", title: "Test Sistem", body: "Какая замечательная история", imageUrl: "baikal", likes: ["QlufJ421c5Xl0TprswE1II2sHXI3"], views: 47, frends: [], createdDate: Date(), updateDate: Date())
        
        print("error:")
        FirestoreManager().addNewPost(post: post) { error in
            print("error:\(error)")
        }

    }
    
    func configure(post: PostFS, with user: User) {
        authorLabel.text = user.getFullName()
        viewsImageView.image = UIImage(systemName: "message")
        if let imageUrl = user.avatar {
            fotoImageView.image = UIImage(named: imageUrl)
        }
        bodyLabel.text = post.body
        likesLabel.text = "\(post.likes.count)"
        viewsLabel.text = "\(post.views)"
        guard let image = post.imageUrl else { return }
        guard let sourceImage = UIImage(named: image) else { return }
        postImageView.image = sourceImage
    }
}

extension PostTableViewCellFS {
    private func setupViews(){
        self.backgroundColor = .createColor(lightMode: .white, darkMode: .systemGray3)
        contentView.addSubviews(fotoImageView,authorLabel, jobLabel, postImageView,bodyLabel, readMore, likesLabel, likesButton,viewsLabel, viewsImageView)
        contentView.layer.cornerRadius = 10
    }
    private func configureConstraints(){
        
        let constraints: [NSLayoutConstraint] = [
            fotoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            fotoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            fotoImageView.heightAnchor.constraint(equalToConstant: 60),
            fotoImageView.widthAnchor.constraint(equalTo: fotoImageView.heightAnchor),
            fotoImageView.trailingAnchor.constraint(equalTo: authorLabel.leadingAnchor, constant: -24),
            fotoImageView.bottomAnchor.constraint(equalTo: bodyLabel.topAnchor, constant: -12),
            
            authorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            authorLabel.bottomAnchor.constraint(equalTo: jobLabel.topAnchor, constant: -4),
            
            jobLabel.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
            jobLabel.bottomAnchor.constraint(lessThanOrEqualTo: bodyLabel.topAnchor, constant: 4),
            
            bodyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bodyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            bodyLabel.bottomAnchor.constraint(equalTo: readMore.topAnchor, constant: -4),
            
            readMore.leadingAnchor.constraint(equalTo: bodyLabel.leadingAnchor),
            readMore.trailingAnchor.constraint(lessThanOrEqualTo: bodyLabel.trailingAnchor),
            readMore.bottomAnchor.constraint(equalTo: postImageView.topAnchor, constant: -16),
            
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            postImageView.widthAnchor.constraint(equalToConstant: Constants.screenWeight - 32),
            postImageView.heightAnchor.constraint(equalToConstant: (Constants.screenWeight) / 3),
            postImageView.bottomAnchor.constraint(equalTo: likesButton.topAnchor, constant: -20),
            postImageView.bottomAnchor.constraint(equalTo: viewsImageView.topAnchor, constant: -20),
            
            likesButton.leadingAnchor.constraint(equalTo: postImageView.leadingAnchor, constant: 16),
            likesButton.trailingAnchor.constraint(equalTo: likesLabel.leadingAnchor, constant: -8),
            likesButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -18),
            likesButton.heightAnchor.constraint(equalToConstant: 20),
            likesButton.widthAnchor.constraint(equalToConstant: 20),
            
            likesLabel.trailingAnchor.constraint(equalTo: viewsImageView.leadingAnchor, constant: -30),
            likesLabel.centerYAnchor.constraint(equalTo: likesButton.centerYAnchor),
            
            viewsImageView.centerYAnchor.constraint(equalTo: likesButton.centerYAnchor),
            viewsImageView.heightAnchor.constraint(equalToConstant: 20),
            viewsImageView.widthAnchor.constraint(equalToConstant: 20),
            viewsImageView.trailingAnchor.constraint(equalTo: viewsLabel.leadingAnchor, constant: -8),
            
            viewsLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 20),
            viewsLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),
            viewsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -18)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
