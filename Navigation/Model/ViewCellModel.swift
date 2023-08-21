//
//
// ViewCellModel.swift
// Navigation
//
// Created by Александр Востриков
//
    
import UIKit

struct ViewCellModel {
    
    let cellType: CellType
    let post: Post
    let user: User
    let friends: [User]
    let userUidForLike: String
    weak var delegate: PostTableViewCellDelegate?
    let tableView: UITableView
    let indexPath: IndexPath
}
