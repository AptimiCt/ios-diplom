//
//  FeedViewController.swift
//  Navigation
//
//  Created by Александр Востриков on 28.11.2021.
//

import UIKit

class FeedViewController: UIViewController, FeedViewControllerProtocol {
    
    private(set) var viewModel: FeedViewModelProtocol!
    
    //MARK: - vars
    private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.toAutoLayout()
        return activityIndicator
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let  refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = . createColor(lightMode: .lightGray, darkMode: .systemGray6)
        tableView.toAutoLayout()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40.0
        return tableView
    }()
    
    //MARK: - init
    init(viewModel: FeedViewModelProtocol){
        self.viewModel = viewModel
        print("FeedViewController создан")
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - override funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupViewModel()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.changeState { [weak self] in
            self?.tableView.reloadData()
        }
    }
    @objc func refresh(sender: UIRefreshControl) {
        viewModel.changeState { [weak self] in
            self?.tableView.reloadData()
            sender.endRefreshing()
        }
    }
    //MARK: - funcs
    private func setupView() {
        title = Constants.navigationItemFeedTitle
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        view.backgroundColor = .createColor(lightMode: .white, darkMode: .systemGray3)
        configureConstraints()
        tableView.refreshControl = refreshControl
    }
    
    private func configureConstraints(){
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        tableView.register(PostTableViewCellFS.self, forCellReuseIdentifier: Cells.cellForPostFeed)
        tableView.register(FriendsViewCell.self, forCellReuseIdentifier: Cells.cellForSectionToCollection)
        
        let constraints: [NSLayoutConstraint] = [
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    //MARK: - setupViewModel
    private func setupViewModel(){
        viewModel.stateChanged = { [weak self] state in
            guard let self else { return }
            switch state {
                case .initial:
                    self.activityIndicator(animate: true)
                case .loaded(let viewModel):
                    self.viewModel = viewModel
                    self.activityIndicator(animate: false)
                    self.tableView.reloadData()
                case .error:
                    break
            }
        }
    }
    private func activityIndicator(animate: Bool){
        activityIndicator.isHidden = !animate
        DispatchQueue.main.async {
            animate ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
        }
    }
    deinit {
        print("FeedViewController удален")
    }
}

//MARK: - extensions
extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count: Int
        let friends = viewModel.getFriens()
        if section == 0 {
            count = friends.isEmpty ? 0 : 1
        } else {
            count = viewModel.numberOfRows()
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.cellForSectionToCollection,
                                                           for: indexPath) as? FriendsViewCell else { return UITableViewCell() }
            cell.friends = viewModel.getFriens()
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.cellForPostFeed) as? PostTableViewCellFS else { return UITableViewCell() }
        
        let post = viewModel.getPostFor(indexPath)
        let user = viewModel.getUser(for: post.userUid)
        cell.configure(post: post, with: user)
        cell.indexPath = indexPath
        cell.delegate = self
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
}

extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.selectionStyle = .none
        if indexPath.section != 0 {
            let post = viewModel.getPostFor(indexPath)
            viewModel.updateViews(postUID: post.postUid)
            viewModel.showDetail(post: post)
        }
    }
}
extension FeedViewController: PostTableViewCellFSDelegate {
    func moreReadButtonTapped(indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

protocol PostTableViewCellFSDelegate: AnyObject {
    func moreReadButtonTapped(indexPath: IndexPath)
}
