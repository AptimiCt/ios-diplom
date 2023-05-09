//
//
// OutputCoordinator.swift
// Navigation
//
// Created by Александр Востриков
//
    

import Foundation
protocol OutputCoordinator {
    var finishFlow: ((User?)->Void)? { get set }
}
