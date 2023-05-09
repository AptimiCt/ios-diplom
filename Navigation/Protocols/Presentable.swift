//
//
// Presentable.swift
// Navigation
//
// Created by Александр Востриков
//
    

import UIKit
protocol Presentable {
    func toPresent() -> UIViewController?
}

extension UIViewController: Presentable {
    func toPresent() -> UIViewController? {
        self
    }
}
