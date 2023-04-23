//
//
// Profile.swift
// Navigation
//
// Created by Александр Востриков
//
    

import Foundation

struct Profile {
    var name: String? = nil
    var lastname: String? = nil
    var foto: String? = nil
    
    mutating func update(with authModel: AuthModel) {
        self.name = authModel.name
        self.lastname = authModel.uid
    }
}
