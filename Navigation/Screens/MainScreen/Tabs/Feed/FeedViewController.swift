//
//  FeedViewController.swift
//  Navigation
//
//  Created by Александр Востриков on 28.11.2021.
//

import UIKit

class FeedViewController: UIViewController, FeedViewControllerProtocol {
    
    private(set) var viewModel: FeedViewModelProtocol!
    var cellFactory: Configurator?
    
    private let notificationForUpdateProfile = Notification.Name(Constants.notifiForUpdateProfile)
    
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
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = . createColor(lightMode: .lightGray, darkMode: .systemGray6)
        tableView.toAutoLayout()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40.0
        return tableView
    }()
    
    //MARK: - init
    init(viewModel: FeedViewModelProtocol) {
        self.viewModel = viewModel
        self.cellFactory = ConfiguratorCell()
        super.init(nibName: nil, bundle: nil)
        Logger.standart.start(on: self)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - override funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupViewModel()
        addNotificationForReloadAllAfterUpdateProfile()
        viewModelChangeState()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    deinit {
        removeNotificationForReloadAllAfterUpdateProfile()
        Logger.standart.remove(on: self)
    }
}

//MARK: - extensions
@objc private extension FeedViewController {
    func reloadDataInScreen(notification: NSNotification) {
        if let dict = notification.object as? NSDictionary {
            if let post = dict["post"] as? Post, let index = dict["index"] as? Int {
                viewModel.updatePost(post: post, for: index)
            }
        }
        tableView.reloadData()
    }
    func refresh(sender: UIRefreshControl) {
        viewModel.changeState { [weak self] in
            self?.tableView.reloadData()
            sender.endRefreshing()
        }
    }
}
private extension FeedViewController {
    func addNotificationForReloadAllAfterUpdateProfile() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadDataInScreen),
                                               name: notificationForUpdateProfile,
                                               object: nil)
    }
    func removeNotificationForReloadAllAfterUpdateProfile() {
        NotificationCenter.default.removeObserver(self, name: notificationForUpdateProfile, object: nil)
    }
    func setupView() {
        title = Constants.navigationItemFeedTitle
    
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: Cells.cellForFeedPostTableViewCell)
        tableView.register(PostTableViewCellWithoutImage.self, forCellReuseIdentifier: Cells.cellForFeedPostTableViewCellWithoutImage)
        tableView.register(FriendsViewCell.self, forCellReuseIdentifier: Cells.cellForSectionToCollection)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.refreshControl = refreshControl
        
        view.backgroundColor = .createColor(lightMode: .white, darkMode: .systemGray3)
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        configureConstraints()
    }
    func configureConstraints(){
        let constraints: [NSLayoutConstraint] = [
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    //MARK: - setupViewModel
    func setupViewModel(){
        viewModel.stateChanged = { [weak self] state in
            guard let self else { return }
            switch state {
                case .initial:
                    self.activityIndicator(animate: true)
                case .loaded(let viewModel):
                    self.viewModel = viewModel
                    self.activityIndicator(animate: false)
                case .error:
                    break
            }
        }
    }
    func activityIndicator(animate: Bool){
        activityIndicator.isHidden = !animate
        DispatchQueue.main.async {
            animate ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
        }
    }
    func viewModelChangeState() {
        viewModel.changeState { [weak self] in
            self?.tableView.reloadData()
        }
    }
}
extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count: Int
        if section == 0 {
            count = viewModel.numberOfSections() == 0 ? 0 : 1
        } else {
            count = viewModel.numberOfRows()
        }
        return count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellFactory = cellFactory else { return UITableViewCell() }
        
        if indexPath.section == 0 {
            let friendsCell = cellFactory.makeCell(cellType: .friendsCell, viewModel: viewModel, delegate: nil, tableView: tableView, for: indexPath)
            return friendsCell
        }
        
        let cellType = viewModel.cellType(at: indexPath)
        return cellFactory.makeCell(cellType: cellType, viewModel: viewModel, delegate: self, tableView: tableView, for: indexPath)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
}

extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.selectionStyle = .none
    }
}
extension FeedViewController: PostTableViewCellDelegate {
    func moreReadButtonTapped(at indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
    }
    func addFavorite(index: Int, completion: @escaping BoolClosure) {
        completion(true)
    }
}
