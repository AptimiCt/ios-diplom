//
//
// Logger.swift
// Navigation
//
// Created by Александр Востриков
//
    

import Foundation

final class Logger {
    static let standard = Logger()
    private init() {}
    func start(on types: AnyObject) {
        #if DEBUG
//        #else
            print("\(String(describing: type(of: types))) создан")
        #endif
    }
    func remove(on types: AnyObject) {
        #if DEBUG
//        #else
            print("\(String(describing: type(of: types))) удален")
        #endif
    }
}
