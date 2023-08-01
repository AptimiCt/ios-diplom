//
//
// StateView.swift
// Navigation
//
// Created by Александр Востриков
//
    

import Foundation

enum StateView {
    case initial
    case loading
    case success
    case failure
    case keyboardWillShow(NSNotification)
    case keyboardWillHide(NSNotification)
}
