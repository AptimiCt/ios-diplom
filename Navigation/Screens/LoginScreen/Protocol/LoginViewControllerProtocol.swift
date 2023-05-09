//
//
// LoginViewControllerProtocol.swift
// Navigation
//
// Created by Александр Востриков
//
    
import UIKit

protocol LoginViewControllerProtocol: Presentable {
    var viewModel: LoginViewModelProtocol { get }
    var loginView: LoginView! { get }
}
