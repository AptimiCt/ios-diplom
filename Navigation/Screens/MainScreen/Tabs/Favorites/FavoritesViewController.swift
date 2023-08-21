//
//  FavoritesViewController.swift
//  Navigation
//
//  Created by Александр Востриков on 25.12.2022.
//

import UIKit

class FavoritesViewController: UIViewController, FavoriteViewControllerProtocol {
    
    //MARK: - vars
    private lazy var tabBarItemFavoritesView = UITabBarItem(
        title: Constants.tabBarItemFavoritesViewTitle,
        image: UIImage(systemName: "star.fill"),
        tag: 3
    )
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = . createColor(lightMode: .systemGray6, darkMode: .systemGray6)
        tableView.separatorStyle = .none
        tableView.toAutoLayout()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        return tableView
    }()
    private lazy var clearFilterButton = UIBarButtonItem(
        image: UIImage(systemName: "checklist.checked"),
        style: .plain,
        target: self,
        action: #selector(clearFilter)
    )
    private lazy var applyFilterButton = UIBarButtonItem(
        image: UIImage(systemName: "checklist"),
        style: .plain,
        target: self,
        action: #selector(applyFilter)
    )
    private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.toAutoLayout()
        return activityIndicator
    }()
    
    private var viewModel: FavoritesViewModelProtocol!
    private var cellFactory: Configurator?
    
    //MARK: - init
    init(viewModel: FavoritesViewModelProtocol) {
        self.viewModel = viewModel
        self.cellFactory = ConfiguratorCell()
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem = tabBarItemFavoritesView
        self.title = Constants.tabBarItemFavoritesViewTitle
        Logger.standard.start(on: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - override funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBarButton()
        setupViewModel()
        updateView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyFilterButton.tintColor = .systemBlue
        updateView()
    }
    deinit {
        Logger.standard.remove(on: self)
    }
}

//MARK: - extensions
@objc private extension FavoritesViewController {
    func clearFilter() {
        viewModel.filterFavorites()
        applyFilterButton.tintColor = .systemBlue
    }
    
    func applyFilter() {
        let alertController = UIAlertController(
            title: "applyFilter.alertController.title".localized,
            message: nil,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "applyFilter.alertController.okAction".localized, style: .default, handler: { [weak self] action in
            guard let textFields = alertController.textFields?[0], let text = textFields.text else { return }
            self?.viewModel.filterFavorites(findText: text, isFiltered: true)
            self?.applyFilterButton.tintColor = .systemRed
        })
        let cancelAction = UIAlertAction(title: "UIAC.cancel".localized, style: .default)
        
        alertController.addTextField()
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }
}

private extension FavoritesViewController {
    func setupView() {
        view.backgroundColor = .createColor(lightMode: .systemGray6, darkMode: .systemGray3)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        configureConstraints()
    }
    func setupNavigationBarButton() {
        navigationItem.rightBarButtonItems = [
            clearFilterButton, applyFilterButton]
    }
    func configureConstraints(){
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: Cells.cellForPostTableViewCell)
        tableView.register(PostTableViewCellWithoutImage.self, forCellReuseIdentifier: Cells.cellForPostTableViewCellWithoutImage)
        
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
    func setupViewModel() {
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
    func activityIndicator(animate: Bool){
        activityIndicator.isHidden = !animate
        DispatchQueue.main.async {
            animate ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
        }
    }
    func updateView() {
        viewModel.changeState { [weak self] in
            self?.tableView.reloadData()
        }
    }
}
//MARK: - extensions UITableViewDataSource
extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cellFactory = cellFactory else { return UITableViewCell() }
        
        let cellType = viewModel.cellType(at: indexPath.row)
        let viewCellModel = ViewCellModel(cellType: cellType,
                                          post: viewModel.getPostFor(indexPath.row),
                                          user: viewModel.getUser(at: indexPath.row),
                                          friends: [],
                                          delegate: nil,
                                          tableView: tableView,
                                          indexPath: indexPath)
        
        return cellFactory.makeCell(viewModel: viewCellModel)
    }
}
//MARK: - extensions UITableViewDelegate
extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectRow(at: indexPath.row)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionDelete = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completion in
            guard let self else { return }
            tableView.beginUpdates()
            viewModel.deletePost(at: indexPath.row) { isDeleted in
                if isDeleted {
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    tableView.endUpdates()
                }
            }
            completion(true)
        }
        actionDelete.image = UIImage(systemName: "trash")
        let configuration = UISwipeActionsConfiguration(actions: [actionDelete])
        return configuration
    }
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        guard let indexPath else { return }
        tableView.cellForRow(at: indexPath)?.layoutSubviews()
    }
}
