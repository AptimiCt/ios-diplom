//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Александр Востриков on 16.12.2021.
//

import UIKit
import SnapKit

protocol ProfileHeaderViewDelegate: AnyObject {
    func didTapedButton()
}

class ProfileHeaderView: UIView {
    
    //MARK: - vars
    var closeButtonTopAnchor: Constraint? = nil
    
    weak var delegate: ProfileHeaderViewDelegate?
    
    let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 50
        imageView.layer.borderWidth = 3
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let setStatusButton: CustomButton = {
        let button = CustomButton(
            title: Constants.showStatus,
            titleColor: .createColor(lightMode: .white,
                                    darkMode: .black)
        )
        button.backgroundColor = .createColor(lightMode: .systemBlue, darkMode: .white)
        button.setTitleColor(.red, for: .highlighted)
        button.layer.cornerRadius = 4
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 4
        button.layer.shadowOffset.width = 4
        button.layer.shadowOffset.height = 4
        return button
    }()
    
    let fullNameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        nameLabel.textColor = .createColor(lightMode: .black, darkMode: .white)
        return nameLabel
    }()
    
    let statusLabel: UILabel = {
        let statusLabel = UILabel()
        statusLabel.text = Constants.status
        statusLabel.font = .systemFont(ofSize: 14, weight: .regular)
        statusLabel.textColor = .createColor(lightMode: .gray, darkMode: .white)
        return statusLabel
    }()
    
    lazy var backgroundView: UIView = {
        let backgroundView = UIView(frame: UIScreen.main.bounds)
        backgroundView.alpha = 0
        backgroundView.backgroundColor = .black
        backgroundView.toAutoLayout()
        return backgroundView
    }()
    
    lazy var closeButton: CustomButton = {
        let closeButton = CustomButton(title: nil, titleColor: nil)
        closeButton.alpha = 0
        closeButton.tintColor = .red
        closeButton.setBackgroundImage(UIImage(systemName: "xmark.circle"), for: .normal)
        closeButton.toAutoLayout()
        return closeButton
    }()
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .createColor(lightMode: .systemGray6, darkMode: .systemGray3)
        self.setupLayerColorFor(traitCollection.userInterfaceStyle)
        addSubviews(fullNameLabel, statusLabel, setStatusButton, backgroundView, closeButton, avatarImageView)
        snpConstraints()
        tapSetStatusButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupLayerColorFor(_ style: UIUserInterfaceStyle) {
        if  style == .dark  {
            setStatusButton.layer.shadowColor = UIColor.white.cgColor
            avatarImageView.layer.borderColor = UIColor.white.cgColor
        } else {
            setStatusButton.layer.shadowColor = UIColor.black.cgColor
            avatarImageView.layer.borderColor = UIColor.black.cgColor
        }
    }
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
    
    //MARK: - private func
    private func tapSetStatusButton(){
        setStatusButton.action = { [weak self] in
            guard let status = self?.statusLabel.text else { return }
            print("\(status)")
        }
    }
}

//MARK: - extension
extension ProfileHeaderView{
    
    fileprivate func snpConstraints() {
        
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
            make.bottom.equalTo(setStatusButton.snp.top).offset(-Constants.topMarginForSetStatusButton)
            make.width.height.equalTo(Constants.heightForAvatarImageView)
        }
        fullNameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(Constants.topMarginForFullNameLabel)
            make.trailing.greaterThanOrEqualTo(self.safeAreaLayoutGuide.snp.trailing).offset(Constants.trailingMarginForFullNameLabel)
        }
        statusLabel.snp.makeConstraints { make in
            make.leading.equalTo(fullNameLabel.snp.leading)
            make.trailing.equalTo(fullNameLabel.snp.trailing)
            make.bottom.equalTo(setStatusButton.snp.top).offset(Constants.bottomMarginForStatusLabel)
        }
        setStatusButton.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(Constants.leadingMarginForSetStatusButton)
            make.top.equalTo(avatarImageView.snp.bottom).offset(Constants.topMarginForSetStatusButton)
            make.trailing.greaterThanOrEqualTo(self.safeAreaLayoutGuide.snp.trailing).offset(Constants.trailingMarginForSetStatusButton)
            make.height.equalTo(Constants.heightForSetStatusButton)
        }
    }
}
