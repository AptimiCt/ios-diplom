//
//
// CommentCell.swift
// Navigation
//
// Created by Александр Востриков
//
    
import UIKit

final class CommentCell: UITableViewCell {
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .createColor(lightMode: .black, darkMode: .white)
        label.numberOfLines = 1
        return label
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .createColor(lightMode: .secondaryLabel, darkMode: .white)
        label.numberOfLines = 1
        return label
    }()
    private let fotoImageView: UIImageView = {
        let image = UIImageView()
        image.toAutoLayout()
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .black
        image.layer.cornerRadius = 30
        image.clipsToBounds = true
        return image
    }()

    private let bodyLabel: UILabel = {
        let description = UILabel()
        description.toAutoLayout()
        description.font = .systemFont(ofSize: 14)
        description.textColor = .createColor(lightMode: .systemGray, darkMode: .white)
        description.numberOfLines = 0
        return description
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        authorLabel.text = nil
        dateLabel.text = nil
        bodyLabel.text = nil
    }
    func configure(commentDataCell: CommentDataCell) {
            authorLabel.text = commentDataCell.user.getFullName()
            let dateFormatter = DateFormatter()
            dateFormatter.locale = .current
            dateFormatter.dateFormat = "d MMM yyyy hh:mm"
            let dateString = dateFormatter.string(from: commentDataCell.comment.date)
            dateLabel.text = dateString
            bodyLabel.text = commentDataCell.comment.body
            if let profilePictureUrl = commentDataCell.user.profilePictureUrl {
                guard let imageUrl = URL(string: profilePictureUrl) else { return }
                fotoImageView.sd_setImage(with: imageUrl)
            }
    }
}

private extension CommentCell {
    func setupViews() {
        contentView.backgroundColor = .createColor(lightMode: .white, darkMode: .systemGray3)
        contentView.addSubviews(fotoImageView,authorLabel, dateLabel,bodyLabel)
    }
    func configureConstraints() {
        let constraints: [NSLayoutConstraint] = [
            fotoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            fotoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            fotoImageView.heightAnchor.constraint(equalToConstant: 60),
            fotoImageView.widthAnchor.constraint(equalTo: fotoImageView.heightAnchor),
            fotoImageView.trailingAnchor.constraint(equalTo: authorLabel.leadingAnchor, constant: -24),
            fotoImageView.bottomAnchor.constraint(equalTo: bodyLabel.topAnchor, constant: -12),
            
            authorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            authorLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: -4),
            
            dateLabel.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
            dateLabel.bottomAnchor.constraint(lessThanOrEqualTo: bodyLabel.topAnchor, constant: 4),
            
            bodyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bodyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            bodyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -18)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
