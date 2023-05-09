//
//  PhotosCollectionViewCell.swift
//  Navigation
//
//  Created by Александр Востриков on 09.02.2022.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    
    let photoImageView: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(photoImageView)
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        photoImageView.pin(to: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
