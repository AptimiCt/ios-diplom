//
//
// UpdateInfoProfileViewModelProtocol.swift
// Navigation
//
// Created by Александр Востриков
//
    

import UIKit

protocol UpdateInfoProfileVidewModelProtocol {
    var user: User { get set }
    func fullName() -> String
}
