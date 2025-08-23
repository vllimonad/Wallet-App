//
//  NetworkManager.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 23/08/2024.
//

import Foundation

protocol NetworkManagerProtocol {
    func fetchRates(completion: @escaping (Result<NBPResponse, Error>) -> Void)
}

final class NetworkManager {
    
    private let ratesUrlString = "https://api.nbp.pl/api/exchangerates/tables/A"
    
}

extension NetworkManager: NetworkManagerProtocol {
    func fetchRates(completion: @escaping (Result<NBPResponse, Error>) -> Void) {
        let request = URLRequest(url: URL(string: ratesUrlString)!)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            guard let nbpResponse = try? JSONDecoder().decode([NBPResponse].self, from: data) else { return }
            completion(.success(nbpResponse.first!))
        }.resume()
    }
}
