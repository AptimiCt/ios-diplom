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
        localStorage = CoreDataManager.dataManager.posts.map { mappingPost(postDataModel: $0) }
        setupView()
    }
    override func viewWillAppear(_ animated: Bool) {
        localStorage = CoreDataManager.dataManager.posts.map { mappingPost(postDataModel: $0) }
        CoreDataManager.dataManager.loadData()
        tableView.reloadData()
    }
    //MARK: - funcs
    private func setupView() {
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        configureConstraints()
    }
    
    private func configureConstraints(){
        view.addSubview(tableView)
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: Cells.cellForPost)
        let constraints: [NSLayoutConstraint] = [
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func mappingPost(postDataModel: PostCoreData) -> Post {
        return Post(author: postDataModel.author ?? "", description: postDataModel.descriptionPost ?? "", image: postDataModel.image ?? "", likes: Int(postDataModel.likes), views: Int(postDataModel.views))
    }
}

//MARK: - extensions
extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        localStorage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.cellForPost) as? PostTableViewCell else { return UITableViewCell() }
        cell.post = localStorage[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
}
