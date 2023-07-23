//
//
// FindFriendViewController.swift
// Navigation
//
// Created by Александр Востриков
//
    
import UIKit

final class FindFriendViewController: UIViewController, FindFriendViewControllerProtocol {
    
    var viewModel: FindFriendViewModelProtocol!

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for Users..."
        return searchBar
    }()

    private let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .createColor(lightMode: .white, darkMode: .systemGray3)
        table.isHidden = true
        table.register(FindFriendCell.self, forCellReuseIdentifier: Cells.cellForFindFriend)
        table.toAutoLayout()
        return table
    }()

    private let noResultsLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "No Results"
        label.textAlignment = .center
        label.textColor = .createColor(lightMode: .black, darkMode: .white)
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.toAutoLayout()
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        setupDelegate()
        isModalInPresentation = true
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(dismissSelf))
        searchBar.becomeFirstResponder()
    }

    @objc private func dismissSelf() {
            NotificationCenter.default.post(
                name: Notification.Name(Constants.notifiForUpdateProfile),
                object: nil
            )
        dismiss(animated: true, completion: nil)
    }
    
}
private extension FindFriendViewController {
    func setupView() {
        view.addSubview(noResultsLabel)
        view.addSubview(tableView)
        view.backgroundColor = .createColor(lightMode: .white, darkMode: .systemGray3)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    func setupLayout() {
        tableView.pin(to: view)
        NSLayoutConstraint.activate([
            noResultsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noResultsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    func setupDelegate() {
        tableView.delegate = self
        tableView.dataSource = self

        searchBar.delegate = self
    }
    func updateUI() {
        if viewModel.numberOfRows() == 0 {
            noResultsLabel.isHidden = false
            tableView.isHidden = true
        }
        else {
            noResultsLabel.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        }
    }  
}
extension FindFriendViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.getResultFor(indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.cellForFindFriend,
                                                 for: indexPath) as! FindFriendCell
        cell.configure(with: model)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let isFriend = viewModel.getResultFor(indexPath).isFriend
        if !isFriend {
            viewModel.addFriend(for: indexPath) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        } else {
            viewModel.removeFromFriend(for: indexPath) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}

extension FindFriendViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        searchBar.resignFirstResponder()
        viewModel.searchUsers(query: text) {
            self.updateUI()
        }
    }
}
