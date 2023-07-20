//
//  CustomButton.swift
//  Navigation
//
//  Created by Александр Востриков on 18.05.2022.
//

import UIKit

final class CustomButton: UIButton {
    
    var action: VoidClosure?
    
    init(title: String? = nil, titleColor: UIColor? = nil) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.toAutoLayout()
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    init(imageSystemName: String) {
        super.init(frame: .zero)
        let config = UIImage.SymbolConfiguration(scale: .large)
        let image = UIImage(systemName: imageSystemName, withConfiguration: config)
        self.setImage(image, for: .normal)
        self.toAutoLayout()
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonTapped(){
        action?()
    }
}
