//
//
// UIButton+Ext.swift
// Navigation
//
// Created by Александр Востриков
//
    

import UIKit

extension UIButton {
    func configureButtons() {
        self.setBackgroundImage(#imageLiteral(resourceName: "blue_pixel"), for: .normal)
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
}
