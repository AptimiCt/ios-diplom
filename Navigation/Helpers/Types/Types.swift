//
//
// Types.swift
// Navigation
//
// Created by Александр Востриков
//
import FirebaseAuth

typealias VoidClosure = () -> Void
typealias AuthenticationCompletionBlock = (AuthDataResult?, AuthenticationError?)-> Void
typealias OptionalErrorClosure = (Error?) -> Void
typealias BoolClosure = (Bool) -> Void
typealias UploadPictureCompletion = (Result<String, Error>) -> Void
