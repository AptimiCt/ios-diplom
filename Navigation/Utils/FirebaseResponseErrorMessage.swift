//
//
// FirebaseResponseErrorMessage.swift
// Navigation
//
// Created by Александр Востриков
//
    

import Foundation
enum FirebaseResponseErrorMessage: String {
    case InvalidEmail = "Не корректный email."
    case RegisterUser = "Отсутсвует такой пользователь. Зарегистрируйте пользователя"
    case WrongPassword = "Не корретный пароль."
    case InternetConnectionProblem = "Проблема с подключением к интернет."
    case TheUserWithThisEmailAlreadyExists = "Пользователь с таким email уже существует."
    case UnknownError = "Не известная ошибка."
    
}
