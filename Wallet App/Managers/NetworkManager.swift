//
//  NetworkManager.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 23/08/2024.
//

import Foundation

class NetworkManager {
    
    static var shared = NetworkManager()
    private let euroRatesUrlString = "https://cdn.jsdelivr.net/gh/fawazahmed0/currency-api@1/latest/currencies/eur.json"
    
    private init() {}
    
    func fetchRate(completion: @escaping (Result<Rate, Error>) -> Void) {
        let request = URLRequest(url: URL(string: euroRatesUrlString)!)
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            guard let rate = try? JSONDecoder().decode(Rate.self, from: data) else { return }
            completion(.success(rate))
        }.resume()
    }
}
