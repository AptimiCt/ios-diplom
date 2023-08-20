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
}

protocol UpdateInfoProfileControllerFactoryProtocol {
    func makeUpdateInfoProfile(with coordinator: UpdateInfoProfileCoordinator, screenType: ScreenType) -> UpdateInfoProfileProtocol
}

protocol ProfileControllerFactoryProtocol {
    func makeProfileController(with coordinator: ProfileCoordinator) -> ProfileViewControllerProtocol
    func makePhotosController() -> PhotosViewControllerProtocol
    func makeFindFriendController(with coordinator: ProfileCoordinator) -> FindFriendViewControllerProtocol
    func makeAddPostController(with coordinator: ProfileCoordinator) -> AddPostViewControllerProtocol
}

protocol FavoriteControllerFactoryProtocol {
    func makeFavoriteController(with coordinator: FavoriteCoordinator) -> FavoriteViewControllerProtocol
}
protocol FeedControllerFactoryProtocol {
    func makeFeedController(with coordinator: FeedCoordinator) -> FeedViewControllerProtocol
    func makePhotosController() -> PhotosViewControllerProtocol
    func makePostDetailController(post: Post, user: User, index: Int) -> PostDetailViewControllerProtocol
}
protocol PostDetailControllerFactoryProtocol {
    func makePostDetailController(post: Post, user: User, index: Int) -> PostDetailViewControllerProtocol
}
protocol SplashControllerFactoryProtocol {
    func makeSplashController() -> SplashViewController
}

protocol ControllersFactoryProtocol: ProfileControllerFactoryProtocol,
                                     FavoriteControllerFactoryProtocol,
                                     FeedControllerFactoryProtocol,
                                     AuthControllerFactoryProtocol,
                                     SplashControllerFactoryProtocol,
                                     PostDetailControllerFactoryProtocol,
                                     UpdateInfoProfileControllerFactoryProtocol,AnyObject {
}
