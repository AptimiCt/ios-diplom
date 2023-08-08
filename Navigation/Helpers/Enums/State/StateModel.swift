//
//
// StateModel.swift
// Navigation
//
// Created by Александр Востриков
//
    

enum StateModel {
    case initial
    case loading
    case success
    case failure(AuthenticationError)
}
