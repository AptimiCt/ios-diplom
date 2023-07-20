//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Александр Востриков on 16.12.2021.
//

import UIKit
import SnapKit

class ProfileHeaderView: UIView {
    
    //MARK: - vars
    var closeButtonTopAnchor: Constraint? = nil
    
    let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 50
        imageView.layer.borderWidth = 3
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let editProfileButton: CustomButton = {
        let button = CustomButton(
            title: Constants.showStatus,
            titleColor: .createColor(lightMode: .white,
                                    darkMode: .black)
        )
        button.backgroundColor = .createColor(lightMode: .systemBlue, darkMode: .white)
        button.setTitleColor(.red, for: .highlighted)
        button.layer.cornerRadius = 10
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 4
        button.layer.shadowOffset.width = 4
        button.layer.shadowOffset.height = 4
        return button
    }()
    let exitButton: CustomButton = {
        let button = CustomButton(imageSystemName: "rectangle.portrait.and.arrow.right.fill")
        button.layer.cornerRadius = 10
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 4
        button.layer.shadowOffset.width = 4
        button.layer.shadowOffset.height = 4
        return button
    }()
    let findFriendsButton: CustomButton = {
        let button = CustomButton(imageSystemName: "person.fill.badge.plus")
        button.layer.cornerRadius = 10
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 4
        button.layer.shadowOffset.width = 4
        button.layer.shadowOffset.height = 4
        return button
    }()
    let addPostButton: CustomButton = {
        let button = CustomButton(imageSystemName: "square.and.pencil")
        button.layer.cornerRadius = 10
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 4
        button.layer.shadowOffset.width = 4
        button.layer.shadowOffset.height = 4
        return button
    }()
    let addPhotoButton: CustomButton = {
        let button = CustomButton(imageSystemName: "photo.fill")
        button.layer.cornerRadius = 10
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 4
        button.layer.shadowOffset.width = 4
        button.layer.shadowOffset.height = 4
        return button
    }()
    let upStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .center
        return stackView
    }()
    let downStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    let fullNameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        nameLabel.textColor = .createColor(lightMode: .black, darkMode: .white)
        return nameLabel
    }()
    
    lazy var backgroundView: UIView = {
        let backgroundView = UIView(frame: UIScreen.main.bounds)
        backgroundView.alpha = 0
        backgroundView.backgroundColor = .black
        backgroundView.toAutoLayout()
        return backgroundView
    }()
    
    lazy var closeButton: CustomButton = {
        let closeButton = CustomButton()
        closeButton.alpha = 0
        closeButton.tintColor = .red
        closeButton.setBackgroundImage(UIImage(systemName: "xmark.circle"), for: .normal)
        closeButton.toAutoLayout()
        return closeButton
    }()
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        snpConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - override func
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard let previousTraitCollection else { return }
        if traitCollection.userInterfaceStyle != previousTraitCollection.userInterfaceStyle {
            if traitCollection.userInterfaceStyle == .light {
                setupLayerColorFor(.light)
            } else {
                setupLayerColorFor(.dark)
            }
        }
    }
}

//MARK: - private extension
private extension ProfileHeaderView {

    func setupViews() {
        addSubviews(
            fullNameLabel,upStackView, downStackView,
            backgroundView, closeButton, avatarImageView
        )
        upStackView.addArrangedSubview(editProfileButton)
        upStackView.addArrangedSubview(exitButton)
        downStackView.addArrangedSubview(addPostButton)
        downStackView.addArrangedSubview(addPhotoButton)
        downStackView.addArrangedSubview(findFriendsButton)
        
        backgroundColor = .createColor(lightMode: .systemGray6, darkMode: .systemGray3)
        setupLayerColorFor(traitCollection.userInterfaceStyle)
    }
    func snpConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height)
        }
        closeButton.snp.makeConstraints { make in
            self.closeButtonTopAnchor = make.top.equalTo(backgroundView.snp.top).offset(8).constraint
            make.trailing.equalTo(self.backgroundView.snp.trailing).offset(-8)
            make.width.height.equalTo(35)
        }
        avatarImageView.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(Constants.leadingMarginForAvatarImageView)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(Constants.topMarginForAvatarImageView)
            make.trailing.equalTo(fullNameLabel.snp.leading).offset(Constants.leadingMarginForFullNameLabel)
            make.width.height.equalTo(Constants.heightForAvatarImageView)
        }
        fullNameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(Constants.topMarginForFullNameLabel)
            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).offset(Constants.trailingMarginForFullNameLabel)
            make.bottom.lessThanOrEqualTo(upStackView.snp.top)
        }
        upStackView.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(Constants.leadingMarginForSetStatusButton)
            make.top.equalTo(avatarImageView.snp.bottom).offset(Constants.topMarginForSetStatusButton)
            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).offset(Constants.trailingMarginForSetStatusButton)
            make.bottom.equalTo(downStackView.snp.top).offset(-16)
        }
        downStackView.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(Constants.leadingMarginForSetStatusButton)
            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).offset(Constants.trailingMarginForSetStatusButton)
            make.bottom.greaterThanOrEqualTo(self.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
        editProfileButton.snp.makeConstraints { make in
            make.height.equalTo(Constants.heightForEditProfileButton)
        }
    }
    func setupLayerColorFor(_ style: UIUserInterfaceStyle) {
        if  style == .dark  {
            editProfileButton.layer.shadowColor = UIColor.white.cgColor
            avatarImageView.layer.borderColor = UIColor.white.cgColor
        } else {
            editProfileButton.layer.shadowColor = UIColor.black.cgColor
            avatarImageView.layer.borderColor = UIColor.black.cgColor
        }
    }
}
