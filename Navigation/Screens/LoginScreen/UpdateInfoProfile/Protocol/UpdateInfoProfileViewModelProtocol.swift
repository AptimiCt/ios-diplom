//
//
// UpdateInfoProfileViewModelProtocol.swift
// Navigation
//
// Created by Александр Востриков
//
    

import UIKit

protocol UpdateInfoProfileVidewModelProtocol {
    var stateChanged: ((StateModelProfile) -> Void)? { get set }
    func updateName(_ name: String)
    
    func updateSurname(_ surname: String)
    
    func updateGender(_ gender: String)
    
    func updateDateOfBirth(_ dateOfBirth: Date)
    
    func updateProfilePicture(_ profilePicture: UIImage)
    
    func showImagePicker()
    
    func updateUser()
    
    func addUser()
    
//    func exit(with user: User?, and error: Error?)
    func exit(with error: Error?)
    
    func setupView()
}
