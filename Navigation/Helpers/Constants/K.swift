//
//
// K.swift
// Navigation
//
// Created by Александр Востриков
//


import Foundation
struct K {
    //MARK: - FilesViewController
    struct FilesVC {
        enum Keys: String {
            case title = "fvcTitle"
        }
    }

    //MARK: - PhotosTableViewCell
    struct PhotosTVCell {
        enum Keys: String {
            case text = "photosLabel.text"
        }
    }
    //MARK: - PhotosViewController
    struct PhotosVC {
        enum Keys: String {
            case text = "photo.gallery"
        }
    }

    //MARK: - FeedViewController
    struct FeedVC {
        enum Keys: String {
            case navigationItemFeedTitle = "navigationItemFeed.title"
            case firstButtonTitle = "firstButton.title"
            case filesTitle = "files.title"
            case checkWordButtonTitle = "checkWordButton.title"
            case wordTextFieldPlaceholder = "wordTextField.placeholder"
            case checkWordButtonTrue = "checkWordButton.true"
            case checkWordButtonFalse = "checkWordButton.false"
        }
    }
    //MARK: - ProfileViewController
    struct ProfileVC {
        enum Keys: String {
            case tabBarItemProfileViewTitle = "tabBarItemProfileView.title"
        }
    }
    //MARK: - ProfileHeaderView
    struct ProfileHV {
        enum Keys: String {
            case editProfileButtonTitle = "editProfileButton.title"
            case statusLabelText = "statusLabel.text"
        }
    }
    //MARK: - LoginViewController
    struct LoginVC {
        enum Keys: String {
            case loginTextViewPlaceholder = "loginTextView.placeholder"
            case passwordTextViewPlaceholder = "passwordTextView.placeholder"
            case loginButtonTitle = "loginButton.title"
            case signUpButtonTitle = "signUpButton.title"
            case biometricsButtonTitle = "biometryButton.title"
            case choosePasswordButtonTitle = "choosePasswordButton.title"
            case choosePasswordButtonSec =  "choose.password.button.sec"
            case tabBarItemLoginVCTitle = "tabBarItemLoginVC.title"
            case alertForErrorTitle = "alertForError.title"
            case alertButtonActionOk = "UIAC.ok"
        }
    }
    //MARK: - FavoritesViewController
    struct FavoritesVC {
        enum Keys: String {
            case tabBarItemFavoritesViewTitle = "tabBarItemFavoritesView.title"
        }
    }
    //MARK: - CurrentUserService
    struct CurrentUserService {
        enum Keys: String {
            case currentUserServiceFullName = "currentUserService.fullName"
        }
    }
    //MARK: - Likes
    struct Likes {
        enum Keys: String {
            case likes = "likes.post"
        }
    }
    //MARK: - Views
    struct Views {
        enum Keys: String {
            case views = "views.post"
        }
    }
}
