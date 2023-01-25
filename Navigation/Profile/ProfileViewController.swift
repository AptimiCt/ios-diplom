//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Александр Востриков on 28.11.2021.
//

import UIKit
import StorageService

class ProfileViewController: UIViewController {
    
    
    //MARK: - vars
    private let tabBarItemProfileView = UITabBarItem(title: Constants.tabBarItemProfileViewTitle,
                                                     image: UIImage(systemName: "person.crop.circle.fill"),
                                                     tag: 1)
    
    private var avatar: UIImageView?
    private var offsetAvatar: CGFloat = 0
    private var userService: UserService
    
    let profileTableHeaderView = ProfileHeaderView()
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = . createColor(lightMode: .white, darkMode: .systemGray6)
        tableView.toAutoLayout()
        return tableView
    }()
    
    var localStorage:[Post] = []
    var photos: [UIImage] = []
    
    //MARK: - init
    
    init(loginName: String, userService: UserService) {
        self.userService = userService
        super.init(nibName: nil, bundle: nil)
        #if DEBUG
        view.backgroundColor = .createColor(lightMode: .systemGray6, darkMode: .systemGray3)
        #else
        view.backgroundColor = .red
        #endif
        self.tabBarItem = tabBarItemProfileView
        guard let user = self.userService.userService(loginName: loginName) else { return }
        profileTableHeaderView.fullNameLabel.text = user.fullName
        profileTableHeaderView.avatarImageView.image = UIImage(named: user.avatar)
        profileTableHeaderView.statusLabel.text = user.status
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - override funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        localStorage = Storage.posts
        photos = Photos.fetchPhotos()
        setupView()
        closeButtonTaped()
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
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: Cells.cellForPost)
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: Cells.cellForSection)
        let constraints: [NSLayoutConstraint] = [
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc private func tapOnAvatar(sender: UITapGestureRecognizer){
        
        let duration: TimeInterval = 0.8
        offsetAvatar = tableView.contentOffset.y
        
        self.avatar = sender.view as? UIImageView
        guard let avatar = avatar else { return }
        
        tableViewInteraction(to: false)
        avatar.isUserInteractionEnabled = false
        
        if offsetAvatar != 0 {
                profileTableHeaderView.closeButtonTopAnchor?.update(offset: offsetAvatar + 8)
        } else {
            profileTableHeaderView.closeButtonTopAnchor?.update(offset: -offsetAvatar+8)
        }
        
        let moveCenter = CGAffineTransform(translationX: Constants.screenWeight / 2 - avatar.frame.width / 2 - 16, y: Constants.screenWeight / 2 + avatar.frame.width + 16 + offsetAvatar)

        let scale = self.view.frame.width / avatar.frame.width
        let scaleToHeight = CGAffineTransform(scaleX: scale, y: scale)
       
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: []) {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.62) {
                self.profileTableHeaderView.backgroundView.alpha = 0.5
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.62) {
                
                avatar.transform = scaleToHeight.concatenating(moveCenter)
                avatar.layer.cornerRadius = 0
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.63, relativeDuration: 0.37) {
                
                self.profileTableHeaderView.closeButton.alpha = 1
            }
        }
        
    }
    
    private func closeButtonTaped(){
        profileTableHeaderView.closeButton.action = {
            guard let avatar = self.avatar else { return }
            
            UIView.animateKeyframes(withDuration: 0.8, delay: 0, options: []) {
                
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.37) {
                    self.profileTableHeaderView.closeButton.alpha = 0
                }
                
                UIView.addKeyframe(withRelativeStartTime: 0.37, relativeDuration: 0.62) {
                    self.profileTableHeaderView.backgroundView.alpha = 0
                }
                
                UIView.addKeyframe(withRelativeStartTime: 0.37, relativeDuration: 0.62) {
                    self.avatar?.layer.cornerRadius = 50
                    avatar.transform = .identity
                    self.view.layoutIfNeeded()
                }
            }
            self.tableViewInteraction(to: true)
            avatar.isUserInteractionEnabled = true
        }
    }
    
    private func tableViewInteraction(to toggle: Bool){
        tableView.allowsSelection = toggle
        tableView.isScrollEnabled = toggle
    }
}

//MARK: - extensions
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 1 : localStorage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.cellForSection,
                                                           for: indexPath) as? PhotosTableViewCell else { return UITableViewCell() }
            cell.photos = photos
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.cellForPost) as? PostTableViewCell else { return UITableViewCell() }
        let post = localStorage[indexPath.row]
        cell.post = post
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnAvatar))
            profileTableHeaderView.avatarImageView.addGestureRecognizer(tapGesture)
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
            let nvc = PhotosViewController()
            navigationController?.pushViewController(nvc, animated: true)
        }
    }
}
