//
//  InfoViewController.swift
//  Navigation
//
//  Created by Александр Востриков on 06.12.2021.
//

import UIKit

final class InfoViewController: UIViewController {
    
    weak var coordinator: FeedCoordinator!
    
    private var peoples: [String] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private let alertButton = CustomButton(title: Constants.alert , titleColor: .createColor(lightMode: .black, darkMode: .white))
    private let firstLabel: UILabel = {
        let firstLabel = UILabel()
        firstLabel.backgroundColor = .systemGreen
        firstLabel.layer.cornerRadius = 15
        firstLabel.clipsToBounds = true
        firstLabel.numberOfLines = 0
        firstLabel.textAlignment = .center
        return firstLabel
    }()
    private let planetLabel: UILabel = {
        let planetLabel = UILabel()
        planetLabel.backgroundColor = .systemOrange
        planetLabel.layer.cornerRadius = 15
        planetLabel.clipsToBounds = true
        planetLabel.numberOfLines = 0
        planetLabel.textAlignment = .center
        return planetLabel
    }()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemTeal
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.peoplesID)
        return tableView
    }()
    
    init(coordinator: FeedCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemTeal
        setupView()
        setupConstraints()
        openFirst(with: Constants.firstUrl)
        openSecond(with: Constants.planetUrl)
    }
    
    private func setupView(){
        alertButton.toAutoLayout()
        firstLabel.toAutoLayout()
        planetLabel.toAutoLayout()
        tableView.toAutoLayout()
        alertButton.backgroundColor = .red
        alertButton.layer.cornerRadius = 15
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubviews(alertButton, firstLabel, planetLabel, tableView)
        
        alertButton.action = { [weak self] in
            guard let self else { return }
            self.coordinator.showAlert(in: self)
            self.tableView.reloadData()
        }
    }
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            alertButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            alertButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            alertButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            alertButton.heightAnchor.constraint(equalToConstant: 40),
            
            firstLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            firstLabel.leadingAnchor.constraint(equalTo: alertButton.leadingAnchor),
            firstLabel.topAnchor.constraint(equalTo: alertButton.bottomAnchor, constant: 20),
            firstLabel.trailingAnchor.constraint(equalTo: alertButton.trailingAnchor),
            firstLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            
            planetLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            planetLabel.leadingAnchor.constraint(equalTo: alertButton.leadingAnchor),
            planetLabel.topAnchor.constraint(equalTo: firstLabel.bottomAnchor, constant: 20),
            planetLabel.trailingAnchor.constraint(equalTo: alertButton.trailingAnchor),
            planetLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.leadingAnchor.constraint(equalTo: alertButton.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: planetLabel.bottomAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: alertButton.trailingAnchor),
            tableView.bottomAnchor.constraint(greaterThanOrEqualTo: view.bottomAnchor, constant: -20)
        ])
    }
    
    private func openFirst(with stringUrl: String){
        guard let url = URL(string: stringUrl) else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            if let data = data {
                do {
                    let serializationDict = try JSONSerialization.jsonObject(with: data, options: [])
                    if let dict = serializationDict as? [String: Any], let title = dict["title"] as? String {
                        DispatchQueue.main.async {
                            self?.firstLabel.text = title
                        }
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
    private func openSecond(with stringUrl: String){
        guard let url = URL(string: stringUrl) else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            if let data = data {
                do {
                    let serializationDict = try JSONDecoder().decode(Planets.self, from: data)
                    DispatchQueue.main.async {
                        self?.planetLabel.text = serializationDict.orbitalPeriod
                    }
                    self?.loadPeople(from: serializationDict.residents)
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
    private func loadPeople(from array: [String]) {
        array.forEach { url in
            guard let url = URL(string: url) else { return }
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                if let data = data {
                    do {
                        let serializationDict = try JSONDecoder().decode(People.self, from: data)
                        self?.peoples.append(serializationDict.name)
                    } catch let error {
                        print(error.localizedDescription)
                    }
                }
            }.resume()
        }
    }
}

extension InfoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        peoples.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.peoplesID, for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = peoples[indexPath.row]
        cell.contentConfiguration = content
        cell.selectionStyle = .none
        return cell
    }
}
