//
//
// ProfileHeaderViewDelegate.swift
// Navigation
//
// Created by Александр Востриков
//
    

import Foundation
struct Dimensions {
    let contentOffset: CGFloat
    let viewFrameWidth: CGFloat
}
protocol ProfileHeaderViewDelegate: AnyObject {
    func tapOnAvatar(completion: @escaping (CGFloat)->Void)
    func closeButtonTaped()
    func editProfileButtonAction()
    func addPostButtonAction()
    func findFriendsButtonAction()
    func exitButtonAction()
}
