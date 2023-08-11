//
//
// LoginViewModelProtocol.swift
// Navigation
//
// Created by Александр Востриков
//
    

import Foundation

protocol LoginViewModelProtocol {
    
    var stateModel: StateModel { get set }
    var stateChanged: ((LoginViewModelProtocol) -> Void)? { get set }
    func checkCredentionalsToLogin(email: String, password: String)
    func checkCredentionalsForRegistration(email: String, password: String)
}
