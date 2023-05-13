//
//
// UpdateInfoProfileViewDelegate.swift
// Navigation
//
// Created by Александр Востриков
//
    

import UIKit

protocol UpdateInfoProfileViewDelegate: AnyObject {
    func updateName(name: String)
    func updateSurname(surname: String)
    func updateGender(gender: String)
    func updateDateOfBirth(dateOfBirth: String)
    func updateProfilePicture(image: UIImage)
    func updateUser()
}
