//
//
// PhotosTableViewCellNew.swift
// Navigation
//
// Created by Александр Востриков
//
    
import UIKit

final class PhotosTableViewCellNew: UITableViewCell {
    
    private lazy var photosLabel: UILabel = {
        let photosLabel = UILabel()
        photosLabel.text = "photosLabel.text".localized
        photosLabel.textColor = .createColor(lightMode: .black, darkMode: .white)
        photosLabel.font = .systemFont(ofSize: 24, weight: .bold)
        photosLabel.toAutoLayout()
        return photosLabel
    }()
    private lazy var arrowButton: CustomButton = {
        let arrowButton = CustomButton()
        arrowButton.setImage(UIImage(systemName: "arrow.forward"), for: .normal)
        arrowButton.tintColor = .createColor(lightMode: .black, darkMode: .white)
        arrowButton.toAutoLayout()
        return arrowButton
    }()
    
    private lazy var photosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.toAutoLayout()
        collectionView.backgroundColor = .createColor(lightMode: .white, darkMode: .systemGray3)
        return collectionView
    }()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.toAutoLayout()
        return stackView
    }()
    
    var viewModel: PhotoViewModel! {
        didSet {
            photosCollectionView.reloadData()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
        configureConstraints()
        self.photosCollectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: Cells.cellForCollection)
        self.photosCollectionView.delegate = self
        self.photosCollectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        
        stackView.addArrangedSubview(photosLabel)
        stackView.addArrangedSubview(arrowButton)
        contentView.addSubviews(stackView, photosCollectionView)
        self.backgroundColor = .createColor(lightMode: .white, darkMode: .systemGray3)
    }

    private func configureConstraints(){
        let constraints = [
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.leadingMarginForPhotosLabel),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.topMarginForPhotosLabel),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.trailingMarginForArrowButton),
            
            photosCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.leadingMarginForFirstPhoto),
            photosCollectionView.topAnchor.constraint(equalTo: photosLabel.bottomAnchor, constant: Constants.topMarginForFirstPhoto),
            photosCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.trailingMarginForFirstPhoto),
            photosCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Constants.bottomForFirstPhoto),
            photosCollectionView.heightAnchor.constraint(equalToConstant: 120),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension PhotosTableViewCellNew: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems() > 10 ? 10 : viewModel.numberOfItems()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.cellForCollection,
                                                                for: indexPath) as! PhotosCollectionViewCell
        let photos = viewModel.getPhoto(at: indexPath.row)
        collectionCell.photoImageView.image = photos
        return collectionCell
    }
}

extension PhotosTableViewCellNew: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 100
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
}
