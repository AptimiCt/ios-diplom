//
//  NetworkManager.swift
//  Navigation
//
//  Created by Александр Востриков on 25.09.2022.
//

import Foundation
struct NetworkManager {
    static func request(for configuration: AppConfiguration?) {
        guard let configuration = configuration else { return }
        switch configuration {
            case .people(let urlString):
                guard let url = URL(string: urlString) else { return }
                dataTask(url)
            case .starships(let urlString):
                if let url = URL(string: urlString){
                    dataTask(url)
                }
            case .planets(let urlString):
                if let url = URL(string: urlString){
                    dataTask(url)
                }
                
        }
        func dataTask(_ url: URL){
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    print("A: \(String(data: data, encoding: .utf8) ?? "")")
                }
                if let response = response as? HTTPURLResponse {
                    print("B: allHeaderFields: \(response.allHeaderFields); \nstatusCode: \(response.statusCode)")
                } else {
                    print("C: \(String(describing: error?.localizedDescription))")
                }
            }.resume()
        }
    }
}

enum AppConfiguration: CaseIterable {
    static var allCases: [AppConfiguration] {
        return [.people(urlString: Constants.people), .starships(urlString: Constants.starships), .planets(urlString: Constants.planets)]
    }
    
    case people(urlString: String)
    case starships(urlString: String)
    case planets(urlString: String)
}
