//
//
// String+Ext.swift
// Navigation
//
// Created by Александр Востриков
//
    

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
