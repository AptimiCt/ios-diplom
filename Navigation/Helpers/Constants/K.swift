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
    //MARK: - CredentialError
    struct CredentialError {
        enum Keys: String {
            case incorrectCredentials
            case emptyEmail
            case emptyPassword
            case emailIsNoCorrect
        }
    }
    //MARK: - FirebaseResponseErrorMessage
    struct FirebaseResponseErrorMessage {
        enum Keys: String {
            case invalidEmail
            case registerUser
            case wrongPassword
            case internetConnectionProblem
            case theUserWithThisEmailAlreadyExists
            case unknownError
        }
    }
    //MARK: - LocationService
    struct LocationService {
        enum Keys: String {
            case restricted
            case denied
            case unknown
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
    //MARK: - Storage
    struct Storage {
        enum Keys: String {
            case firstPostAuthor = "firstPost.author"
            case firstPostDescription = "firstPost.description"
            case secondPostAuthor = "secondPost.author"
            case secondPostDescription = "secondPost.description"
            case thirdPostAuthor = "thirdPost.author"
            case thirdPostDescription = "thirdPost.description"
            case fourthPostAuthor = "fourthPost.author"
            case fourthPostDescription = "fourthPost.description"
        }
    }
    //MARK: - InfoViewController
    struct InfoVC {
        enum Keys: String {
            case alertButtonTitle = "alertButton.title"
            case alertButtonActionTitle = "alertButton.action.title"
            case alertButtonActionMessage = "alertButton.action.message"
            case alertButtonActionCancel = "alertButton.action.cancel"
            case alertButtonActionOk = "alertButton.action.ok"
            case alertButtonActionCancelPressed = "alertButton.action.cancel.pressed"
            case alertButtonActionOkPressed = "alertButton.action.ok.pressed"
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
            case setStatusButtonTitle = "setStatusButton.title"
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
            case alertButtonActionOk = "alertButton.action.ok"
        }
    }
    //MARK: - FavoritesViewController
    struct FavoritesVC {
        enum Keys: String {
            case tabBarItemFavoritesViewTitle = "tabBarItemFavoritesView.title"
        }
    }
    //MARK: - MapViewController
    struct MapVC {
        enum Keys: String {
            case tabBarItemMapTitle = "tabBarItemMap.title"
        }
    }
    //MARK: - TestUserService
    struct TestUserService {
        enum Keys: String {
            case testUserServiceFullName = "testUserService.fullName"
        }
    }
    //MARK: - CurrentUserService
    struct CurrentUserService {
        enum Keys: String {
            case currentUserServiceFullName = "currentUserService.fullName"
        }
    }
    //MARK: - SceneDelegate
    struct SceneDelegate {
        enum Keys: String {
            case post = "sceneDelegate.post"
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
