//
//
// UpdateInfoProfileViewModel.swift
// Navigation
//
// Created by Александр Востриков
//
    

import UIKit

final class UpdateInfoProfileViewModel: UpdateInfoProfileVidewModelProtocol {
    
    var user: User
    
    init(user: User) {
        self.user = user
    }
    func fullName() -> String {
        user.fullName
    }
}
