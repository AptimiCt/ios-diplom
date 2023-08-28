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
    private lazy var toolbarTextField: UITextField = {
        let textField = UITextField()
        textField.toAutoLayout()
        textField.placeholder = "Введите сообщение"
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true

        return textField
    }()
    private lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect(x: 0,
                                              y: 0,
                                              width: view.bounds.width,
                                              height: 44))
        toolbar.isTranslucent = true
        let addComment = UIBarButtonItem(
            image: UIImage(systemName: "arrow.turn.right.up"),
            style: .plain,
            target: self,
            action: #selector(addComment)
        )
        let textField = UIBarButtonItem(customView: toolbarTextField)
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.setItems([flexible, textField, flexible, addComment], animated: false)
        return toolbar
    }()
    private var toolbarBottomConstraint: NSLayoutConstraint?
    
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Реакция на появление и скрытие клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollToLastRow()
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
    func addComment() {
        guard let text = toolbarTextField.text, text.count > 3 else { return }
        toolbarTextField.text = nil
        viewModel.addComment(with: text) { [weak self] _ in
            self?.scrollToLastRow()
        }
    }
    //Обработка появление клавиатуры
    func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let animationDuration: TimeInterval = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.25
        toolbarBottomConstraint?.constant = -keyboardSize.height + view.safeAreaInsets.bottom
        UIView.animate(withDuration: animationDuration, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: { [weak self] in
            self?.view.layoutIfNeeded()
            self?.scrollToLastRow()
        })
    }
    //Обработка скрытия клавиатуры
    func keyboardWillHide(notification: NSNotification) {
        toolbarBottomConstraint?.constant = 0
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
    func scrollToLastRow() {
        let indexPath = IndexPath(row: viewModel.numberOfRows() - 1, section: 0)
        if indexPath.row > 1 {
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    func setupView() {
        view.backgroundColor = .createColor(lightMode: .systemGray6, darkMode: .systemGray3)
        view.addSubviews(tableView, activityIndicator, toolbar)
        toolbar.toAutoLayout()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = refreshControl
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        tableView.register(CommentCell.self, forCellReuseIdentifier: Cells.cellForCommentCell)
        toolbarTextField.delegate = self
        postView.delegate = self
        configureConstraints()
        toolbar.sizeToFit()
        toolbarTextField.sizeToFit()
    }
    func configureConstraints(){
        let constraints: [NSLayoutConstraint] = [
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: toolbar.bottomAnchor),
            
            toolbar.widthAnchor.constraint(equalToConstant: Constants.screenWeight),
            toolbar.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        toolbarBottomConstraint = toolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        toolbarBottomConstraint?.isActive = true
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
extension PostDetailControllerWithComments: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, text.count > 3 else { return  true}
        textField.text = nil
        viewModel.addComment(with: text) { [weak self] _ in
            self?.scrollToLastRow()
        }
        return true
    }
}
