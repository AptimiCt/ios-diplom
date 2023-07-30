//
//
// ConfiguratorCell.swift
// Navigation
//
// Created by Александр Востриков
//

import UIKit

protocol Configurator {
    
    func makeCell(cellType: CellType,
                  viewModel: FeedViewModelProtocol,
                  delegate: PostTableViewCellDelegate?,
                  tableView: UITableView,
                  for indexPath: IndexPath
    ) -> UITableViewCell
}
