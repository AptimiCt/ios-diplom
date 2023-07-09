//
//
// FindFriendCell.swift
// Navigation
//
// Created by Александр Востриков
//
    
import Foundation
import SDWebImage

class FindFriendCell: UITableViewCell {

    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.layer.masksToBounds = true
        imageView.toAutoLayout()
        return imageView
    }()

    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .semibold)
        label.toAutoLayout()
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func configure(with model: SearchResult) {
        userNameLabel.text = model.name
        if let profileImageUrl = model.profileImageUrl {
            guard let url = URL(string: profileImageUrl) else { return }
            DispatchQueue.main.async {
                self.userImageView.sd_setImage(with: url, completed: nil)
            }
        } else {
            DispatchQueue.main.async {
                self.userImageView.image = UIImage(named: "avatar")
            }
        }
        if model.isFriend {
            self.accessoryView = UIImageView(image: UIImage(systemName: "checkmark.circle"))
        } else {
            self.accessoryView = nil
        }
    }
}

private extension FindFriendCell {
    func setupView() {
        self.backgroundColor = .createColor(lightMode: .white, darkMode: .systemGray3)
        contentView.addSubviews(userNameLabel, userImageView)
    }
    func setupLayout() {
        NSLayoutConstraint.activate([
            userImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            userImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            userImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            userImageView.heightAnchor.constraint(equalToConstant: 100),
            userImageView.widthAnchor.constraint(equalToConstant: 100),
            
            userNameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 10),
            userNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -5),
            userNameLabel.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor)
        ])
    }
}
