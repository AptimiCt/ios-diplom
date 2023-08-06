//
//
// BodyImageViewCellViewModel.swift
// Navigation
//
// Created by Александр Востриков
//
    

import UIKit

final class BodyImageViewCellViewModel {
    
    enum CellType {
        case text
        case image
    }
    
    private(set) var bodyText: String
    let type: CellType

    private(set) var image: UIImage?
    private(set) var onCellUpdate: (() -> Void)?
    
    init(bodyText: String, type: CellType, onCellUpdate: (() -> Void)?) {
        self.bodyText = bodyText
        self.type = type
        self.onCellUpdate = onCellUpdate
    }
    
    func update(_ bodyText: String) {
        self.bodyText = bodyText
    }
    
    func update(_ image: UIImage) {
        self.image = image
        onCellUpdate?()
    }
}
