//
//
// ControllersFactoryProtocol.swift
// Navigation
//
// Created by Александр Востриков
//
    

import UIKit

protocol AuthControllerFactoryProtocol {
    func makeLoginController(with coordinator: LoginCoordinator) -> LoginViewControllerProtocol
    //func makeEditProfile(user: User) -> EditProfileProtocol
}

protocol ProfileControllerFactoryProtocol {
    func makeProfileController(with user: User, and coordinator: ProfileCoordinator) -> ProfileViewControllerProtocol
    func makePhotosController() -> PhotosViewControllerProtocol
}

protocol FavoriteControllerFactoryProtocol {
    func makeFavoriteController() -> FavoriteViewControllerProtocol
}
protocol FeedControllerFactoryProtocol {
    func makeFeedController(with user: User, and coordinator: ProfileCoordinator) -> ProfileViewControllerProtocol
    func makePhotosController() -> PhotosViewControllerProtocol
}