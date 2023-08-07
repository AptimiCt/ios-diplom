//
//
// ConfiguratorCell.swift
// Navigation
//
// Created by Александр Востриков
//

import UIKit

protocol Configurator {
    func makeCell(viewModel: ViewCellModel) -> UITableViewCell
}
