//
//
// LoginViewDelegate.swift
// Navigation
//
// Created by Александр Востриков
//
    

import Foundation

protocol LoginViewDelegate: AnyObject {
    func login(email: String, password: String, completion: @escaping ()->Void)
    func signUp(email: String, password: String, completion: @escaping ()->Void)
    func loginWithBiometrics()
    func buttonTapped(with error: Error)
}
