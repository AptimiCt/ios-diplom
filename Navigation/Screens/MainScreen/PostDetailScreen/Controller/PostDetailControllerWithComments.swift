//
//
// PostDetailControllerWithComments.swift
// Navigation
//
// Created by Александр Востриков
//
    
import UIKit

final class PostDetailControllerWithComments: UIViewController, PostDetailViewControllerProtocol {
    
    //MARK: - vars
    private var viewModel: PostDetailViewModelWithCommentsProtocol!
    
    //MARK: - ui
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
    
    private lazy var postView: PostView = PostView()
    
    private lazy var  tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .createColor(lightMode: .white, darkMode: .systemGray3)
        tableView.tableHeaderView = postView
        tableView.toAutoLayout()
        return tableView
    }()
    
    
    //MARK: - init
    init(viewModel: PostDetailViewModelWithCommentsProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
        updateView()
    }
    deinit {
        Logger.standard.remove(on: self)
    }
}

//MARK: - extensions
//MARK: - @objc private extension
@objc private extension PostDetailControllerWithComments {
    func refresh(sender: UIRefreshControl) {
        viewModel.changeState { [weak self] in
            self?.tableView.reloadData()
            sender.endRefreshing()
        }
    }
}
//MARK: - private extension
private extension PostDetailControllerWithComments {
    //MARK: - setupViewModel
    func setupViewModel(){
        viewModel.stateChanged = { [weak self] state in
            guard let self else { return }
            switch state {
                case .initial:
                    self.activityIndicator(animate: true)
                    self.postView.stateView = .initial
                case .success(let viewModel):
                    self.viewModel = viewModel
                    self.postView.stateView = .success(viewModel.getPost())
                    self.activityIndicator(animate: false)
                    self.tableView.reloadData()
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
    func setupView() {
        view.backgroundColor = .createColor(lightMode: .systemGray6, darkMode: .systemGray3)
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = refreshControl
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        tableView.register(CommentCell.self, forCellReuseIdentifier: Cells.cellForCommentCell)
        
        postView.delegate = self
        configureConstraints()
    }
    func configureConstraints(){
        let constraints: [NSLayoutConstraint] = [
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
//MARK: - UITableViewDataSource
extension PostDetailControllerWithComments: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.cellForCommentCell, for: indexPath) as? CommentCell else { return UITableViewCell() }
        let commentDataCell = viewModel.getComment(at: indexPath.row)
        cell.configure(commentDataCell: commentDataCell)
        return cell
    }
}
//MARK: - UITableViewDelegate
extension PostDetailControllerWithComments: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.selectionStyle = .none
    }
}
extension PostDetailControllerWithComments: PostViewDelegate {
    func likesButtonTapped() {
        viewModel.likesButtonTapped()
    }
}
