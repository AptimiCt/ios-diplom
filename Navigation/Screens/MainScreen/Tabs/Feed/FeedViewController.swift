//
//  FeedViewController.swift
//  Navigation
//
//  Created by Александр Востриков on 28.11.2021.
//

import UIKit
import StorageService

class FeedViewController: UIViewController, FeedViewControllerProtocol {
    
    private(set) var viewModel: FeedViewModelProtocol!
    private(set) var coordinator: FeedCoordinator!
    private var userService: UserService
    private var photos: [UIImage] = []
    
    //MARK: - vars
    private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.toAutoLayout()
        return activityIndicator
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = . createColor(lightMode: .lightGray, darkMode: .systemGray6)
        tableView.toAutoLayout()
        return tableView
    }()
    
    //MARK: - init
    init(coordinator: FeedCoordinator, viewModel: FeedViewModelProtocol, userService: UserService){
        self.viewModel = viewModel
        self.userService = userService
        self.coordinator = coordinator
        print("FeedViewController создан")
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .createColor(lightMode: .white, darkMode: .systemGray3)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - override funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        photos = Photos.fetchPhotos()
        setupView()
        setupViewModel()
        finishFlow()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.changeState { [weak self] in
            self?.tableView.reloadData()
        }
    }
    //MARK: - funcs
    private func setupView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        configureConstraints()
    }
    
    private func configureConstraints(){
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        tableView.register(PostTableViewCellFS.self, forCellReuseIdentifier: Cells.cellForPostFeed)
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: Cells.cellForSection)
        
        let constraints: [NSLayoutConstraint] = [
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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
    
    //Переход поток авторизации
    func finishFlow() {
        //        profileTableHeaderView.closeButton.action = { [weak self] in
        //            self?.coordinator.finishFlow?(nil)
        //        }
    }
    deinit {
        print("FeedViewController удален")
    }
}

//MARK: - extensions
extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 1 : viewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.cellForSection,
                                                           for: indexPath) as? PhotosTableViewCell else { return UITableViewCell() }
            cell.photos = photos
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.cellForPostFeed) as? PostTableViewCellFS else {
            return UITableViewCell() }
        cell.post = viewModel.getPostFor(indexPath)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
}

extension FeedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.selectionStyle = .none
        if indexPath.section == 0 {
            coordinator.showPhotosVC()
        }
    }
}
