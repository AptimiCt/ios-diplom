//
//  PostTableViewCell.swift
//  Navigation
//
//  Created by Александр Востриков on 30.01.2022.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    weak var delegate: PostTableViewCellDelegate?
    var indexPath: IndexPath!
    
    private let constantHeightPostImageView = (Constants.screenWeight) / 3
    private lazy var heightAnchorPostImageView: NSLayoutConstraint = postImageView.heightAnchor.constraint(equalToConstant: constantHeightPostImageView)
    
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
        image.backgroundColor = .black
        image.layer.cornerRadius = 30
        image.clipsToBounds = true
        return image
    }()
    private lazy var postImageView: UIImageView = {
        let image = UIImageView()
        image.toAutoLayout()
        image.contentMode = .scaleToFill
        image.backgroundColor = .black
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        return image
    }()
    private lazy var bodyLabel: UILabel = {
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
        readMore.setTitle("PTVC.readMore.title".localized, for: .normal)
        readMore.setTitleColor(.systemBlue, for: .normal)
        readMore.setTitleColor(.systemGray, for: .highlighted)
        readMore.addTarget(self, action: #selector(readMoreButtonTapped), for: .touchUpInside)
        return readMore
    }()
    private lazy var likesButton: UIButton = {
        var config = UIButton.Configuration.borderedTinted()
        config.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
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
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        configureConstraints()
        addDoubleTapRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        postImageView.image = nil
        authorLabel.text = nil
        dateLabel.text = nil
        bodyLabel.text = nil
        likesButton.setImage(UIImage(systemName: "heart"), for: .normal)
        fotoImageView.image = nil
        indexPath = nil
        
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
    }
    func configure(post: Post, with user: User, and userForLike: String) {
        authorLabel.text = user.getFullName()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateFormat = "d MMM yyyy hh:mm"
        let dateString = dateFormatter.string(from: post.createdDate)
        dateLabel.text = dateString
        bodyLabel.text = post.body
        if isLiked(postLikes: post.likes, userForLike: userForLike) {
            likesButton.tintColor = .systemRed
            likesButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            likesButton.tintColor = .createColor(lightMode: .black, darkMode: .white)
            likesButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        likesButton.setTitle("\(post.likes.count)", for: .normal)
        viewsImageView.setTitle("\(post.views)", for: .normal)
        if let profilePictureUrl = user.profilePictureUrl {
            guard let imageUrl = URL(string: profilePictureUrl) else { return }
            fotoImageView.sd_setImage(with: imageUrl)
        }
        if let postImageUrl = post.imageUrl {
            guard let imageUrl = URL(string: postImageUrl) else { return }
            postImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(systemName: "photo"))
        }
    }
}
private extension PostTableViewCell {
    func isLiked(postLikes: [String], userForLike: String) -> Bool {
        var isLiked = false
        if postLikes.contains(userForLike) {
            isLiked = true
        }
        return isLiked
    }
    func visualizeAdd(color: UIColor) {
        contentView.backgroundColor = color
        UIView.animate(withDuration: 1, delay: 0) {
            self.contentView.backgroundColor = .createColor(lightMode: .white, darkMode: .systemGray3)
        }
    }
    func addDoubleTapRecognizer() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(addPostToFavorite))
        doubleTap.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTap)
    }
}
@objc private extension PostTableViewCell {
    func readMoreButtonTapped(){
        delegate?.moreReadButtonTapped(at: indexPath)
    }
    func addPostToFavorite() {
        delegate?.addFavorite(index: indexPath.row) { [weak self] isFavorite in
            isFavorite ? self?.visualizeAdd(color: .systemGreen) : self?.visualizeAdd(color: .systemRed)
        }
    }
    func likesButtonTapped() {
        delegate?.likesButtonTapped(at: indexPath.row)
    }
}
private extension PostTableViewCell {
    func setupViews(){
        contentView.backgroundColor = .createColor(lightMode: .white, darkMode: .systemGray3)
        contentView.addSubviews(fotoImageView, authorLabel,
                                dateLabel, postImageView,
                                bodyLabel, readMore, footerStackView)
        footerStackView.addArrangedSubview(likesButton)
        footerStackView.addArrangedSubview(viewsImageView)
    }
    func configureConstraints(){
        let constraints: [NSLayoutConstraint] = [
            fotoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            fotoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            fotoImageView.heightAnchor.constraint(equalToConstant: 60),
            fotoImageView.widthAnchor.constraint(equalToConstant: 60),
            fotoImageView.trailingAnchor.constraint(equalTo: authorLabel.leadingAnchor, constant: -24),
            fotoImageView.bottomAnchor.constraint(equalTo: bodyLabel.topAnchor, constant: -12),
            
            authorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            authorLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: -4),
            
            dateLabel.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
            dateLabel.bottomAnchor.constraint(lessThanOrEqualTo: bodyLabel.topAnchor, constant: 4),
            
            bodyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bodyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            bodyLabel.bottomAnchor.constraint(equalTo: readMore.topAnchor, constant: -4),
            
            readMore.leadingAnchor.constraint(equalTo: bodyLabel.leadingAnchor),
            readMore.trailingAnchor.constraint(lessThanOrEqualTo: bodyLabel.trailingAnchor),
            readMore.bottomAnchor.constraint(equalTo: postImageView.topAnchor, constant: -16),
            
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            postImageView.widthAnchor.constraint(equalToConstant: Constants.screenWeight - 32),
            postImageView.bottomAnchor.constraint(equalTo: likesButton.topAnchor, constant: -20),
            postImageView.bottomAnchor.constraint(equalTo: footerStackView.topAnchor, constant: -20),
            
            footerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 16),
            footerStackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -30),
            footerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ]
        NSLayoutConstraint.activate(constraints)
        heightAnchorPostImageView.isActive = true
    }
}
