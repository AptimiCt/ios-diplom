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
    private var closeButtonTopAnchor: Constraint? = nil
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 50
        imageView.layer.borderWidth = 3
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var editProfileButton: CustomButton = {
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
    lazy var exitButton: CustomButton = {
        let button = CustomButton(imageSystemName: "rectangle.portrait.and.arrow.right.fill")
        button.layer.cornerRadius = 10
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 4
        button.layer.shadowOffset.width = 4
        button.layer.shadowOffset.height = 4
        return button
    }()
    private lazy var findFriendsButton: CustomButton = {
        let button = CustomButton(imageSystemName: "person.fill.badge.plus")
        button.layer.cornerRadius = 10
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 4
        button.layer.shadowOffset.width = 4
        button.layer.shadowOffset.height = 4
        return button
    }()
    private lazy var addPostButton: CustomButton = {
        let button = CustomButton(imageSystemName: "square.and.pencil")
        button.layer.cornerRadius = 10
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 4
        button.layer.shadowOffset.width = 4
        button.layer.shadowOffset.height = 4
        return button
    }()
    private lazy var addPhotoButton: CustomButton = {
        let button = CustomButton(imageSystemName: "photo.fill")
        button.layer.cornerRadius = 10
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 4
        button.layer.shadowOffset.width = 4
        button.layer.shadowOffset.height = 4
        return button
    }()
    private lazy var upStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .center
        return stackView
    }()
    private lazy var downStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    private lazy var fullNameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        nameLabel.textColor = .createColor(lightMode: .black, darkMode: .white)
        return nameLabel
    }()
    
    private lazy var backgroundView: UIView = {
        let backgroundView = UIView(frame: .zero)
        backgroundView.alpha = 0
        backgroundView.backgroundColor = .black
        backgroundView.toAutoLayout()
        return backgroundView
    }()
    
    private lazy var closeButton: CustomButton = {
        let closeButton = CustomButton()
        closeButton.alpha = 0
        closeButton.tintColor = .red
        closeButton.setBackgroundImage(UIImage(systemName: "xmark.circle"), for: .normal)
        closeButton.toAutoLayout()
        return closeButton
    }()
    
    weak var delegate: ProfileHeaderViewDelegate?
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        snpConstraints()
        actionsForProfileTableHeaderViewButton()
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
    func configureView(viewModel: ProfileHeaderViewModel) {
        if let urlString = viewModel.profilePictureUrl, let url = URL(string: urlString) {
            avatarImageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "person"))
        } else {
            avatarImageView.image = UIImage(named: Constants.defaultProfilePicture)
        }
        fullNameLabel.text = viewModel.fullName
    }
}

//MARK: - private extension
@objc private extension ProfileHeaderView {
    func tapOnAvatar() {
        let duration: TimeInterval = 0.8
        backgroundView.isUserInteractionEnabled = true
        avatarImageView.isUserInteractionEnabled = false
        delegate?.tapOnAvatar { [weak self] offsetAvatar in
            guard let self else { return }
        
            if offsetAvatar != 0 {
                    self.closeButtonTopAnchor?.update(offset: offsetAvatar + 8)
            } else {
                self.closeButtonTopAnchor?.update(offset: -offsetAvatar + 8)
            }
            
            let moveCenter = CGAffineTransform(translationX: Constants.screenWeight / 2 - avatarImageView.frame.width / 2 - 16, y: Constants.screenWeight / 2 + avatarImageView.frame.width + 16 + offsetAvatar)

            let scale = Constants.screenWeight / self.avatarImageView.frame.width
            let scaleToHeight = CGAffineTransform(scaleX: scale, y: scale)
           
            UIView.animateKeyframes(withDuration: duration, delay: 0, options: []) {
                
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.62) {
                    self.backgroundView.alpha = 0.5
                }
                
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.62) {
                    self.avatarImageView.transform = scaleToHeight.concatenating(moveCenter)
                    self.avatarImageView.layer.cornerRadius = 0
                }
                
                UIView.addKeyframe(withRelativeStartTime: 0.63, relativeDuration: 0.37) {
                    self.closeButton.alpha = 1
                }
            }
        }
    }
}

private extension ProfileHeaderView {
    func actionsForProfileTableHeaderViewButton() {
        closeButton.action = {  [weak self] in
            self?.delegate?.closeButtonTaped()
            UIView.animateKeyframes(withDuration: 0.8, delay: 0, options: []) {
                
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.37) {
                    self?.closeButton.alpha = 0
                }
                
                UIView.addKeyframe(withRelativeStartTime: 0.37, relativeDuration: 0.62) {
                    self?.backgroundView.alpha = 0
                }
                
                UIView.addKeyframe(withRelativeStartTime: 0.37, relativeDuration: 0.62) {
                    self?.avatarImageView.layer.cornerRadius = 50
                    self?.avatarImageView.transform = .identity
                    self?.avatarImageView.layoutIfNeeded()
                }
            }
            self?.avatarImageView.isUserInteractionEnabled = true
        }
        
        editProfileButton.action = { [weak self] in
            self?.delegate?.editProfileButtonAction()
        }
        addPostButton.action = { [weak self] in
            self?.delegate?.addPostButtonAction()
        }
        findFriendsButton.action = { [weak self] in
            self?.delegate?.findFriendsButtonAction()
        }
        exitButton.action = { [weak self] in
            self?.delegate?.exitButtonAction()
        }
    }
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnAvatar))
        avatarImageView.addGestureRecognizer(tapGesture)
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
