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
    func updateDateOfBirth(dateOfBirth: Date)
    func updateProfilePicture(image: UIImage)
    func choicePhoto()
    func updateUser()
    func addUser()
}
