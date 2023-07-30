//
//
// PostTableViewCellDelegate .swift
// Navigation
//
// Created by Александр Востриков
//
    
import UIKit

protocol PostTableViewCellDelegate: AnyObject {
    func moreReadButtonTapped()
    func addFavorite(index: Int, completion: @escaping BoolClosure)
}
