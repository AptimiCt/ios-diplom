//
//  Constants.swift
//  Navigation
//
//  Created by Александр Востриков on 15.01.2022.
//

import UIKit

struct Constants {
    
    static let filesRID = "FilesTableViewCell"
    //MARK: - Constants for ProfileTableHederView
    static let screenWeight = UIScreen.main.bounds.width
    
    //MARK: - Constants for PostTableViewCell
    //MARK: - for AvatarImageView
    static let leadingMarginForAvatarImageView: CGFloat = 16
    static let topMarginForAvatarImageView: CGFloat = 16
    static let heightForAvatarImageView: CGFloat = 100
    
    //MARK: - for fullNameLabel
    static let leadingMarginForFullNameLabel: CGFloat = -20
    static let topMarginForFullNameLabel: CGFloat = 27
    static let trailingMarginForFullNameLabel: CGFloat = -16
    
    //MARK: - for setStatusButton
    static let leadingMarginForSetStatusButton: CGFloat = 16
    static let topMarginForSetStatusButton: CGFloat = 16
    static let trailingMarginForSetStatusButton: CGFloat = -16
    static let heightForEditProfileButton: CGFloat = 44
    
    //MARK: - Constants for ProfileViewController
    //MARK: - for profileHeaderView
    static let heightForProfileHeaderView: CGFloat = 250
    
    
    //MARK: - Constants for LoginViewController
    //MARK: - for logoImageView
    
    static let topMarginForLogoImageView: CGFloat = 120
    static let heightForLogoImageView: CGFloat = 100
    static let widthForLogoImageView: CGFloat = 100
    
    //MARK: - for stackView
    static let leadingMarginForStackView: CGFloat = 16
    static let topMarginForStackView: CGFloat = 120
    static let trailingMarginForStackView: CGFloat = -16
    static let heightForStackView: CGFloat = 100
    
    //MARK: - for loginButton
    static let topMarginForLoginButton: CGFloat = 16
    static let heightForLoginButton: CGFloat = 50
    
    //MARK: - Constants for PhotosTableViewCell
    //MARK: - for photosLabel
    static let leadingMarginForPhotosLabel: CGFloat = 12
    static let topMarginForPhotosLabel: CGFloat = 12
    
    //MARK: - for arrowButton
    static let topMarginForArrowButton: CGFloat = 12
    static let trailingMarginForArrowButton: CGFloat = -12
    
    //MARK: - for firstPhoto
    static let leadingMarginForFirstPhoto: CGFloat = 12
    static let topMarginForFirstPhoto: CGFloat = 12
    static let trailingMarginForFirstPhoto: CGFloat = -8
    static let bottomForFirstPhoto: CGFloat = -12
    
    //MARK: - for secondPhoto
    static let trailingMarginForSecondPhoto: CGFloat = -8
    static let bottomForSecondPhoto: CGFloat = -12
    
    //MARK: - for thirdPhoto
    static let trailingMarginForThirdPhoto: CGFloat = -8
    static let bottomForThirdPhoto: CGFloat = -12
    
    //MARK: - for fourthPhoto
    static let trailingMarginForFourthPhoto: CGFloat = -12
    static let bottomForFourthPhoto: CGFloat = -12
    
    //MARK: - for Checker
    static let login = "Джейк Салли".hash
    static let password = "StrongPassword".hash

    //MARK: - Constant string
    //MARK: - CurrentUserService
    static let currentUserServiceFullName = ~K.CurrentUserService.Keys.currentUserServiceFullName.rawValue
    
    
    //MARK: - ProfileHeaderView
    static let showStatus = ~K.ProfileHV.Keys.editProfileButtonTitle.rawValue
    static let status = ~K.ProfileHV.Keys.statusLabelText.rawValue
    
    //MARK: - LoginViewController
    static let logIn = ~K.LoginVC.Keys.loginButtonTitle.rawValue
    static let signUp = ~K.LoginVC.Keys.signUpButtonTitle.rawValue
    static let logInWithBiometrics = ~K.LoginVC.Keys.biometricsButtonTitle.rawValue
    static let loginTextViewPlaceholder = ~K.LoginVC.Keys.loginTextViewPlaceholder.rawValue
    static let passwordTextViewPlaceholder = ~K.LoginVC.Keys.passwordTextViewPlaceholder.rawValue
    static let choosePassword = ~K.LoginVC.Keys.choosePasswordButtonTitle.rawValue
    static let tabBarItemLoginVCTitle = ~K.LoginVC.Keys.tabBarItemLoginVCTitle.rawValue
    static let titleAlert = ~K.LoginVC.Keys.alertForErrorTitle.rawValue
    
    //MARK: - FeedViewController
    static let navigationItemFeedTitle = ~K.FeedVC.Keys.navigationItemFeedTitle.rawValue
    static let firstButton = ~K.FeedVC.Keys.firstButtonTitle.rawValue
    static let files = ~K.FeedVC.Keys.filesTitle.rawValue
    static let checkWord = ~K.FeedVC.Keys.checkWordButtonTitle.rawValue
    static let wordTextField = ~K.FeedVC.Keys.wordTextFieldPlaceholder.rawValue
    static let checkWordButtonTrue = ~K.FeedVC.Keys.checkWordButtonTrue.rawValue
    static let checkWordButtonFalse = ~K.FeedVC.Keys.checkWordButtonFalse.rawValue
    
    //MARK: - ProfileViewController
    static let tabBarItemProfileViewTitle = ~K.ProfileVC.Keys.tabBarItemProfileViewTitle.rawValue
    
    //MARK: - FavoritesViewController
    static let tabBarItemFavoritesViewTitle = ~K.FavoritesVC.Keys.tabBarItemFavoritesViewTitle.rawValue
    
    //MARK: - PhotosTableViewCell
    static let photosLabelText = ~K.PhotosTVCell.Keys.text.rawValue
    
    //MARK: - PhotosViewController
    static let photoGalleryText = ~K.PhotosVC.Keys.text.rawValue
    
    static let defaultProfilePicture = "defaultProfilePicture"
    
    static let people = "https://swapi.dev/api/people/8"
    static let starships = "https://swapi.dev/api/starships/3"
    static let planets = "https://swapi.dev/api/planets/5"
    static let dataModel = "PostDataModel"
    
    static let notifyForUpdateProfile = "updateProfile"
    
    static let notificationForNewPost = "newPost"
}
