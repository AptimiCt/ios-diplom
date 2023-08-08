//
//
// FirestoreDatabaseError.swift
// Navigation
//
// Created by Александр Востриков
//
    

enum FirestoreDatabaseError: Error {
    case failureGetPost
    case failedToUpload
    case failedToGetDownloadUrl
    case error(description: String)
}
