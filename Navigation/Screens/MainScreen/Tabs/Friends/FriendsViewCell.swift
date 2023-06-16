//
//
// FriendsCollectionViewCell.swift
// Navigation
//
// Created by Александр Востриков
//

import UIKit

final class FriendsViewCell: UITableViewCell {
    
    private let friendsLabel: UILabel = {
        let friendsLabel = UILabel()
        friendsLabel.text = "friendsLabel.text".localized
        friendsLabel.textColor = .createColor(lightMode: .black, darkMode: .white)
        friendsLabel.font = .systemFont(ofSize: 24, weight: .bold)
        friendsLabel.toAutoLayout()
        return friendsLabel
    }()
    
    private let friendsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.toAutoLayout()
        collectionView.backgroundColor = .createColor(lightMode: .white, darkMode: .systemGray3)
        return collectionView
    }()
    var friends: [User] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
        configureConstraints()
        self.friendsCollectionView.register(FriendsCollectionViewCell.self, forCellWithReuseIdentifier: Cells.cellForFriendsCollectionViewCell)
        self.friendsCollectionView.delegate = self
        self.friendsCollectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        contentView.addSubviews(friendsLabel, friendsCollectionView)
        self.backgroundColor = .createColor(lightMode: .white, darkMode: .systemGray3)
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
    }

    private func configureConstraints(){
        let constraints = [
            friendsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.leadingMarginForPhotosLabel),
            friendsLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.topMarginForPhotosLabel),
            friendsLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.leadingAnchor, constant: Constants.screenWeight - 100),

            friendsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.leadingMarginForFirstPhoto),
            friendsCollectionView.topAnchor.constraint(equalTo: friendsLabel.bottomAnchor, constant: Constants.topMarginForFirstPhoto),
            friendsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.trailingMarginForFirstPhoto),
            friendsCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Constants.bottomForFirstPhoto),
            friendsCollectionView.heightAnchor.constraint(equalToConstant: 120),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension FriendsViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friends.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.cellForFriendsCollectionViewCell,
                                                                for: indexPath) as! FriendsCollectionViewCell
        let friend = friends[indexPath.item]
        collectionCell.configure(user: friend)
        return collectionCell
    }
}

extension FriendsViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 100
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
}
