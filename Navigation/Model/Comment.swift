//
//
// Comment.swift
// Navigation
//
// Created by Александр Востриков
//
    
import Foundation

struct Comment: Codable {
    let userUid: String
    let postUid: String
    let body: String
    let date: Date
}
