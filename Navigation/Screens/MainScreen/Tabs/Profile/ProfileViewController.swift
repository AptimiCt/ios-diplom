//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Александр Востриков on 28.11.2021.
//

import UIKit

class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    
    private var viewModel: ProfileViewModelProtocol!
    private var cellFactory: Configurator?
    
    //MARK: - vars
    private let tabBarItemProfileView = UITabBarItem(title: Constants.tabBarItemProfileViewTitle,
                                                     image: UIImage(systemName: "person.crop.circle.fill"),
                                                     tag: 1)
    
    private var avatar: UIImageView?
    private var offsetAvatar: CGFloat = 0
    private let notificationForUpdateProfile = Notification.Name(Constants.notifyForUpdateProfile)
    private let notificationForNewPost = Notification.Name(Constants.notificationForNewPost)

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.toAutoLayout()
        return activityIndicator
    }()
    private lazy var refreshControl: UIRefreshControl = {
        let  refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    var profileTableHeaderView: ProfileHeaderView! = ProfileHeaderView()
    
    private lazy var  tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = . createColor(lightMode: .systemGray6, darkMode: .systemGray6)
        tableView.toAutoLayout()
        return tableView
    }()
    
    
    //MARK: - init
    init(viewModel: ProfileViewModelProtocol) {
        self.viewModel = viewModel
        self.cellFactory = ConfiguratorCell()
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem = tabBarItemProfileView
        Logger.standard.start(on: self)
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
        viewModel.changeState { [weak self] in
            self?.tableView.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        tableView.reloadData()
    }
    
    deinit {
        removeNotificationForReloadAllAfterUpdateProfile()
        Logger.standard.remove(on: self)
    }
}

//MARK: - extensions
//MARK: - @objc private extension
@objc private extension ProfileViewController {
    func reloadDataInScreen(notification: NSNotification) {
        if let dict = notification.object as? NSDictionary {
            if let post = dict["post"] as? Post, let index = dict["index"] as? Int {
                viewModel.updatePost(post: post, for: index)
            }
        }
        updateView()
    }
    func reloadDataInScreenNewPost(notification: NSNotification) {
        if let dict = notification.object as? NSDictionary {
            if let post = dict["post"] as? Post, let index = dict["index"] as? Int {
                viewModel.newPost(post: post, for: index)
            }
        }
        updateView()
    }
    func refresh(sender: UIRefreshControl) {
        viewModel.changeState { [weak self] in
            self?.tableView.reloadData()
            sender.endRefreshing()
        }
    }
}
//MARK: - private extension
private extension ProfileViewController {

    func showAlertSheet() {
        let alertSheet = UIAlertController(
            title: nil,
            message: "PVC.alertSheet.title".localized,
            preferredStyle: .actionSheet
        )
        let exitAction = UIAlertAction(
            title: "PVC.alertSheet.exitAction".localized,
            style: .destructive
        ) { [weak self] _ in
            self?.viewModel.finishFlow()
        }
        let cancelAction = UIAlertAction(
            title: "UIAC.cancel".localized,
            style: .cancel
        )
        
        alertSheet.addAction(exitAction)
        alertSheet.addAction(cancelAction)
        alertSheet.popoverPresentationController?.sourceView = self.profileTableHeaderView.exitButton
        
        present(alertSheet, animated: true)
    }
    
    func addNotificationForReloadAllAfterUpdateProfile() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadDataInScreen),
                                               name: notificationForUpdateProfile,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadDataInScreenNewPost),
                                               name: notificationForNewPost,
                                               object: nil)

    }
    func removeNotificationForReloadAllAfterUpdateProfile() {
        NotificationCenter.default.removeObserver(self, name: notificationForUpdateProfile, object: nil)
        NotificationCenter.default.removeObserver(self, name: notificationForNewPost, object: nil)
    }
    func updateProfileHeaderView() {
        let profileHeaderViewModel = ProfileHeaderViewModel(
                                        fullName: viewModel.getUser().getFullName(),
                                        profilePictureUrl: viewModel.getUser().profilePictureUrl
                                     )
        profileTableHeaderView.configureView(viewModel: profileHeaderViewModel)
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
                    self.updateProfileHeaderView()
                    self.tableView.reloadData()
                case .error:
                    break
            }
        }
    }
    func updateView() {
        viewModel.changeState { [weak self] in
            self?.tableView.reloadData()
        }
    }
    func activityIndicator(animate: Bool){
        activityIndicator.isHidden = !animate
        DispatchQueue.main.async {
            animate ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
        }
    }
    func tableViewInteraction(to toggle: Bool){
        tableView.allowsSelection = toggle
        tableView.isScrollEnabled = toggle
    }
    func setupView() {
        view.backgroundColor = .createColor(lightMode: .systemGray6, darkMode: .systemGray3)
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = refreshControl
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: Cells.cellForPostTableViewCell)
        tableView.register(PostTableViewCellWithoutImage.self, forCellReuseIdentifier: Cells.cellForPostTableViewCellWithoutImage)
        tableView.register(PhotosTableViewCellNew.self, forCellReuseIdentifier: Cells.cellForSectionNew)
        
        profileTableHeaderView.delegate = self
        configureConstraints()
    }
    func configureConstraints(){
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
}
//MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 1 : viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellFactory = cellFactory else { return UITableViewCell() }
        
        if indexPath.section == 0 && !viewModel.getPhotos().isEmpty {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: Cells.cellForSectionNew,
                for: indexPath
            ) as? PhotosTableViewCellNew else { return UITableViewCell() }
            let photos = viewModel.getPhotos()
            let viewModel = PhotoViewModel(photo: photos)
            cell.viewModel = viewModel
            return cell
        }
        let cellType = viewModel.cellType(at: indexPath.row)
        
        let viewCellModel = ViewCellModel(cellType: cellType,
                                          post: viewModel.getPostFor(indexPath.row),
                                          user: viewModel.getUser(),
                                          friends: [],
                                          userUidForLike: viewModel.getUser().uid,
                                          delegate: self,
                                          tableView: tableView,
                                          indexPath: indexPath)
        
        return cellFactory.makeCell(viewModel: viewCellModel)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
}
//MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return profileTableHeaderView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? Constants.heightForProfileHeaderView : 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.selectionStyle = .none
        if indexPath.section == 0 {
            viewModel.showPhotosVC()
        }
    }
}
//MARK: - PostTableViewCellDelegate
extension ProfileViewController: PostTableViewCellDelegate {
    func moreReadButtonTapped(at indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath.row)
    }
    func addFavorite(index: Int, completion: @escaping BoolClosure) {
        viewModel.addCoreData(index) { isFavorite in
            completion(isFavorite)
        }
    }
    func likesButtonTapped(at index: Int) {
        viewModel.likesButtonTapped(at: index)
    }
}
extension ProfileViewController: ProfileHeaderViewDelegate {
    
    func tapOnAvatar(completion: @escaping (CGFloat) -> Void) {
        tableViewInteraction(to: false)
        completion(tableView.contentOffset.y)
    }
    func closeButtonTaped() {
        self.tableViewInteraction(to: true)
    }
    func editProfileButtonAction() {
        viewModel.showEditProfileVC()
    }
    func addPostButtonAction() {
        viewModel.showAddPostVC()
    }
    func findFriendsButtonAction() {
        viewModel.showFindFriendVC()
    }
    //Переход в поток авторизации
    func exitButtonAction() {
        showAlertSheet()
    }
}
