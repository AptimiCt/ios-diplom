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
    func makeUpdateInfoProfile(with coordinator: LoginCoordinator, screenType: ScreenType) -> UpdateInfoProfileProtocol
}

protocol ProfileControllerFactoryProtocol {
    func makeProfileController(with coordinator: ProfileCoordinator) -> ProfileViewControllerProtocol
    func makePhotosController() -> PhotosViewControllerProtocol
}

protocol FavoriteControllerFactoryProtocol {
    func makeFavoriteController() -> FavoriteViewControllerProtocol
}
protocol FeedControllerFactoryProtocol {
    func makeFeedController(with coordinator: FeedCoordinator) -> FeedViewControllerProtocol
    func makePhotosController() -> PhotosViewControllerProtocol
}

protocol ControllersFactoryProtocol: ProfileControllerFactoryProtocol,
                                     FavoriteControllerFactoryProtocol,
                                     FeedControllerFactoryProtocol,
                                     AuthControllerFactoryProtocol {
}
