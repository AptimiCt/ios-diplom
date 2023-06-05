//
//
// FriendsCollectionViewCell.swift
// Navigation
//
// Created by Александр Востриков
//
    

import UIKit

class FriendsCollectionViewCell: UICollectionViewCell {
    
    let photoImageView: UIImageView = {
        let photoImageView = UIImageView()
        photoImageView.toAutoLayout()
        photoImageView.layer.cornerRadius = 15
        photoImageView.clipsToBounds = true
        return photoImageView
    }()
    let fullNameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.numberOfLines = 1
        nameLabel.font = .systemFont(ofSize: 12, weight: .regular)
        nameLabel.backgroundColor = UIColor(red: 0.28, green: 0.52, blue: 0.80, alpha: 0.60)
        nameLabel.layer.cornerRadius = 5
        nameLabel.clipsToBounds = true
        nameLabel.textAlignment = .center
        nameLabel.toAutoLayout()
        return nameLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(user: User) {
        if let photo = user.avatar, !photo.isEmpty {
            photoImageView.image = UIImage(named: photo)
        } else {
            photoImageView.image = UIImage(systemName: "person.crop.square.fill")
        }
        fullNameLabel.text = user.getFullName()
    }
}

private extension FriendsCollectionViewCell {
    func configureView() {
        self.addSubviews(photoImageView, fullNameLabel)
        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            photoImageView.topAnchor.constraint(equalTo: self.topAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            fullNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            fullNameLabel.topAnchor.constraint(lessThanOrEqualTo: photoImageView.bottomAnchor, constant: 44),
            fullNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            fullNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
        ])
    }
}
