//
//
// LoginViewDelegate.swift
// Navigation
//
// Created by Александр Востриков
//
    

import Foundation

protocol LoginViewDelegate: AnyObject {
    func login(email: String, password: String)
    func signUp(email: String, password: String)
    func loginWithBiometrics()
}
