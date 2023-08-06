//
//
// AddPostViewControllerNew.swift
// Navigation
//
// Created by Александр Востриков
//

import UIKit

final class AddPostViewController: UIViewController, AddPostViewControllerProtocol {
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = . createColor(lightMode: .systemGray6, darkMode: .systemGray6)
        table.toAutoLayout()
        table.estimatedRowHeight = 44
        table.rowHeight = UITableView.automaticDimension
        return table
    }()
    
    var viewModel: AddPostViewModel!
    
    init(viewModel: AddPostViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        Logger.standard.start(on: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        viewModel.onUpdate = { [weak self] in
            self?.tableView.reloadData()
        }
        viewModel.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewDidDisappear()
    }
    deinit {
        Logger.standard.remove(on: self)
    }
}
@objc private extension AddPostViewController {
    func tappedDone() {
        viewModel.tappedDone()
    }
    func addImage() {
        viewModel.addImage()
    }
}
private extension AddPostViewController {
    func setupViews() {
        view.backgroundColor = .createColor(lightMode: .systemGray6, darkMode: .systemGray3)
        
        navigationItem.title = viewModel.title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tappedDone))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(addImage))
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(BodyImageViewCell.self, forCellReuseIdentifier: Cells.cellForBodyImageViewCell)
        
        view.addSubview(tableView)
        let constraints: [NSLayoutConstraint] = [
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
extension AddPostViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = viewModel.cell(for: indexPath)
        switch cellViewModel {
            case .bodyImageView(let cellViewModel):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.cellForBodyImageViewCell, for: indexPath) as? BodyImageViewCell else { return UITableViewCell() }
                cell.update(with: cellViewModel)
                cell.bodyTextView.delegate = self
                return cell
        }
    }
}

extension AddPostViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        viewModel.didSelectRow(at: indexPath)
    }
}

extension AddPostViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        guard let currentText = textView.text, let textRange = Range(range, in: currentText) else { return true }
        
        let updatedText = currentText.replacingCharacters(in: textRange, with: text)
        let point = textView.convert(textView.bounds.origin, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: point) {
            viewModel.updateCell(indexPath: indexPath, text: updatedText)
        }
        return true
    }
}
