//
//
// ConfiguratorCell.swift
// Navigation
//
// Created by Александр Востриков
//
    

import UIKit

struct ConfiguratorCell: Configurator {
    
    private let cellsIdentifier: [CellType: String] = [
        .postWithImageCell: Cells.cellForPostTableViewCell,
        .postCell: Cells.cellForPostTableViewCellWithoutImage,
    ]
    
    func makeCell(viewModel: ViewCellModel) -> UITableViewCell {
        switch viewModel.cellType {
            case .postWithImageCell:
                guard let cell = viewModel.tableView.dequeueReusableCell(withIdentifier: cellsIdentifier[viewModel.cellType] ?? "", for: viewModel.indexPath) as? PostTableViewCell else { return UITableViewCell() }
                cell.configure(post: viewModel.post, with: viewModel.user)
                cell.indexPath = viewModel.indexPath
                cell.delegate = viewModel.delegate
                return cell
            case .postCell:
                guard let cell = viewModel.tableView.dequeueReusableCell(withIdentifier: cellsIdentifier[viewModel.cellType] ?? "", for: viewModel.indexPath) as? PostTableViewCellWithoutImage else { return UITableViewCell() }
                cell.configure(post: viewModel.post, with: viewModel.user)
                cell.indexPath = viewModel.indexPath
                cell.delegate = viewModel.delegate
                return cell
        }
    }
}
