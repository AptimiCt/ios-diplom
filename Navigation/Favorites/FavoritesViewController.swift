//
//  FavoritesViewController.swift
//  Navigation
//
//  Created by Александр Востриков on 25.12.2022.
//

import UIKit
import StorageService

class FavoritesViewController: UIViewController {
    
    //MARK: - vars
    private let tabBarItemFavoritesView = UITabBarItem(title: Constants.tabBarItemFavoritesViewTitle,
                                                       image: UIImage(systemName: "star.fill"),
                                                       tag: 3)
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.toAutoLayout()
        return tableView
    }()
    
    var localStorage: [Post] = []
    
    //MARK: - init
    init() {
        super.init(nibName: nil, bundle: nil)
        #if DEBUG
        view.backgroundColor = .systemGray6
        #else
        view.backgroundColor = .systemRed
        #endif
        self.tabBarItem = tabBarItemFavoritesView
        self.title = Constants.tabBarItemFavoritesViewTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - override funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBarButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CoreDataManager.dataManager.fetch(predicate: nil) {[weak self] result in
            guard let self else { return }
            self.localStorage = CoreDataManager.dataManager.posts.map { self.mappingPost(postDataModel: $0) }
            self.tableView.reloadData()
        }
    }
    //MARK: - funcs
    private func setupView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        configureConstraints()
    }
    private func setupNavigationBarButton() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "checklist.checked"), style: .plain, target: self, action: #selector(clearFilter)),
            UIBarButtonItem(image: UIImage(systemName: "checklist"), style: .plain, target: self, action: #selector(applyFilter))]
    }
    private func configureConstraints(){
        view.addSubview(tableView)
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: Cells.cellForPostFavorites)
        let constraints: [NSLayoutConstraint] = [
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func mappingPost(postDataModel: PostCoreData) -> Post {
        return Post(id: Int(postDataModel.identifier) ,author: postDataModel.author ?? "", description: postDataModel.descriptionPost ?? "", image: postDataModel.image ?? "", likes: Int(postDataModel.likes), views: Int(postDataModel.views))
    }
}

//MARK: - extensions
@objc private extension FavoritesViewController {
    func clearFilter() {
        print(#function)
    }
    
    func applyFilter() {
        print(#function)
    }
}
extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        localStorage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.cellForPostFavorites) as? PostTableViewCell else { return UITableViewCell() }
        cell.post = localStorage[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
}

extension FavoritesViewController: UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionDelete = UIContextualAction(style: .destructive, title: nil) { _, _, completion in
            //let cell = tableView.cellForRow(at: indexPath)
            let post = self.localStorage[indexPath.row]
            print(post)
            completion(true)
        }
        actionDelete.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [actionDelete])
    }
}
