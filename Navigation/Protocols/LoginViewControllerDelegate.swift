//
//  LoginViewControllerDelegate.swift
//  Navigation
//
//  Created by Александр Востриков on 14.10.2022.
//

import Foundation

protocol LoginViewControllerDelegate: AnyObject {
   
    func checkCredentionalsInspector(email: String, password: String, completion: @escaping (Result<AuthModel, NSError>) -> Void )
    func signUpInspector(email: String, password: String, completion: @escaping (Result<AuthModel, NSError>) -> Void )
}
