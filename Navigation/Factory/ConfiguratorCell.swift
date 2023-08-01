//
//
// ConfiguratorCell.swift
// Navigation
//
// Created by Александр Востриков
//
    

import UIKit

struct ConfiguratorCell: Configurator {
    
    func makeCell(cellType: CellType,
                  viewModel: FeedViewModelProtocol,
                  delegate: PostTableViewCellDelegate? = nil,
                  tableView: UITableView,
                  for indexPath: IndexPath
    ) -> UITableViewCell {
                
                switch cellType {
                    case .friendsCell:
                        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.cellForSectionToCollection, for: indexPath) as? FriendsViewCell else { return UITableViewCell() }
                        cell.friends = viewModel.getFriens()
                        return cell
                    case .postWithImageCell:
                        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.cellForFeedPostTableViewCell, for: indexPath) as? PostTableViewCell else { return UITableViewCell() }
                        let post = viewModel.getPostFor(indexPath)
                        
                        let user = viewModel.getUser(for: post.userUid)
                        cell.configure(post: post, with: user)
                        cell.indexPath = indexPath
                        cell.delegate = delegate
                        return cell
                    case .postCell:
                        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.cellForFeedPostTableViewCellWithoutImage, for: indexPath) as? PostTableViewCellWithoutImage else { return UITableViewCell() }
                        let post = viewModel.getPostFor(indexPath)
                        let user = viewModel.getUser(for: post.userUid)
                        cell.configure(post: post, with: user)
                        cell.indexPath = indexPath
                        cell.delegate = delegate
                        return cell
                }
    }
}
