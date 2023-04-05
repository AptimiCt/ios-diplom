//
//  UIView+Extension.swift
//  Navigation
//
//  Created by Александр Востриков on 06.02.2022.
//

import UIKit

extension UIView {
    
    func toAutoLayout(){
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addSubviews(_ subviews: UIView...){
        subviews.forEach { addSubview($0)}
    }
    
    func pin(to superView: UIView){
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
        topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
    }
}
