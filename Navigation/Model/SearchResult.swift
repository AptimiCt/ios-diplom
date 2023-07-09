//
//
// SearchResult.swift
// Navigation
//
// Created by Александр Востриков
//
    
struct SearchResult {
    let uid: String
    let name: String
    let profileImageUrl: String?
    var isFriend: Bool
}
extension SearchResult: Equatable {
    static func == (lhs: SearchResult, rhs: SearchResult) -> Bool {
        lhs.uid == rhs.uid
    }
}
