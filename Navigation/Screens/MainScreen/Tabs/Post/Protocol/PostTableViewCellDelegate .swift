//
//
// PostTableViewCellDelegate .swift
// Navigation
//
// Created by Александр Востриков
//
    
import UIKit

protocol PostTableViewCellDelegate: AnyObject {
    func moreReadButtonTapped(at: IndexPath)
    func addFavorite(index: Int, completion: @escaping BoolClosure)
}
