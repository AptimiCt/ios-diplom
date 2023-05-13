//
//
// CustomLabel.swift
// Navigation
//
// Created by Александр Востриков
//
    

import UIKit

final class CustomLabel: UILabel {
    
    init(title: String? = nil) {
        super.init(frame: .zero)
        self.text = title
        self.textColor = .secondaryLabel
        self.toAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
