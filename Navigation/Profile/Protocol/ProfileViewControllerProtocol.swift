//
//
// ProfileViewControllerProtocol.swift
// Navigation
//
// Created by Александр Востриков
//
    

import UIKit

protocol ProfileViewControllerProtocol: Presentable {
    var viewModel: ProfileViewModelProtocol! { get }
    var coordinator: ProfileCoordinator! { get }
}
