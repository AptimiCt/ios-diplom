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
    
    let setStatusButton: CustomButton = {
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
    
    let statusTextField: TextFieldWithPadding = {
        let statusTextField = TextFieldWithPadding()
        statusTextField.placeholder = Constants.status
        statusTextField.font = .systemFont(ofSize: 15, weight: .regular)
        statusTextField.textColor = .createColor(lightMode: .gray, darkMode: .white)
        statusTextField.attributedPlaceholder = NSAttributedString(string: Constants.status,
                                                                    attributes: [NSAttributedString.Key.foregroundColor : UIColor.createColor(lightMode: .placeholderText, darkMode: .white)])
        statusTextField.layer.cornerRadius = 12
        statusTextField.layer.borderWidth = 1
        statusTextField.layer.borderColor = UIColor.black.cgColor
        statusTextField.backgroundColor = .createColor(lightMode: .systemGray6, darkMode: .gray)
        return statusTextField
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
        addSubviews(
            fullNameLabel, statusLabel,
            statusTextField, setStatusButton,
            backgroundView, closeButton, avatarImageView
        )
        statusTextField.addTarget(self, action: #selector(statusTextChanged), for: .editingChanged)
        self.backgroundColor = .createColor(lightMode: .systemGray6, darkMode: .systemGray3)
        self.setupLayerColorFor(traitCollection.userInterfaceStyle)
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
//        setStatusButton.action = { [weak self] in
//            guard let status = self?.statusLabel.text else { return }
//            print("\(status)")
//
//        }
        
    }
    @objc func statusTextChanged(_ textField: UITextField) {
        guard let statusText = textField.text else { return }
        if statusText != "" {
            self.statusLabel.text = statusText
        } else {
            self.statusLabel.text = statusTextField.placeholder
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
            make.width.height.equalTo(Constants.heightForAvatarImageView)
        }
        fullNameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(Constants.topMarginForFullNameLabel)
            make.trailing.lessThanOrEqualTo(self.safeAreaLayoutGuide.snp.trailing).offset(Constants.trailingMarginForFullNameLabel)
        }
        statusLabel.snp.makeConstraints { make in
            make.leading.equalTo(fullNameLabel.snp.leading)
            make.trailing.equalTo(fullNameLabel.snp.trailing)
            make.bottom.equalTo(statusTextField.snp.top).offset(-10)
            make.bottom.equalTo(avatarImageView.snp.bottom).offset(-18)
        }
        statusTextField.snp.makeConstraints { make in
            make.leading.equalTo(statusLabel.snp.leading)
            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).offset(Constants.trailingMarginForSetStatusButton)
            make.height.equalTo(40)
            make.bottom.equalTo(setStatusButton.snp.top).offset(-10)
        }
        setStatusButton.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(Constants.leadingMarginForSetStatusButton)
            make.top.greaterThanOrEqualTo(avatarImageView.snp.bottom).offset(Constants.topMarginForSetStatusButton)
            make.trailing.greaterThanOrEqualTo(self.safeAreaLayoutGuide.snp.trailing).offset(Constants.trailingMarginForSetStatusButton)
            make.height.equalTo(Constants.heightForSetStatusButton)
        }
    }
}
