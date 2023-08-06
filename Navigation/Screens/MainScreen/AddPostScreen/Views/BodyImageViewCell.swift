//
//
// BobyImageViewCell.swift
// Navigation
//
// Created by Александр Востриков
//
    

import UIKit
import RSKPlaceholderTextView

final class BodyImageViewCell: UITableViewCell {
    
    private let placeholder = "Что нового?"
    
    lazy var bodyTextView: RSKPlaceholderTextView = {
        let bodyTextView = RSKPlaceholderTextView()
        bodyTextView.placeholder = NSString(string: placeholder)
        bodyTextView.becomeFirstResponder()
        bodyTextView.font = .systemFont(ofSize: 20, weight: .medium)
        //Краш приложения при включенной автокоррекции.
        bodyTextView.autocorrectionType = .no
        bodyTextView.isScrollEnabled = false
        return bodyTextView
    }()
    private lazy var verticalStackView = UIStackView()
    
    private lazy var photoImageView: UIImageView = {
        let photoImageView = UIImageView()
        return photoImageView
    }()
    private lazy var photoImageViewHeightAnchor = photoImageView.heightAnchor.constraint(equalToConstant: 200)
    private var viewModel: BodyImageViewCellViewModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with viewModel: BodyImageViewCellViewModel) {
        self.viewModel = viewModel
        
        bodyTextView.text = viewModel.bodyText
        bodyTextView.isHidden = viewModel.type == .image
        
        photoImageView.isHidden = viewModel.type != .image
        photoImageView.image = viewModel.image
        if viewModel.type == .image {
            photoImageViewHeightAnchor.isActive = true
        }else {
            photoImageViewHeightAnchor.isActive = false
        }
    }
    
    private func setupViews() {
        verticalStackView.axis = .vertical
        [verticalStackView, bodyTextView, photoImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupHierarchy() {
        contentView.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(bodyTextView)
        verticalStackView.addArrangedSubview(photoImageView)
    }
    
    private func setupLayout() {

        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            verticalStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            verticalStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
        ])
    }
    
}
