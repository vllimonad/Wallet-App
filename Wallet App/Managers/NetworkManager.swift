//
//  NetworkManager.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 23/08/2024.
//

import Foundation

class NetworkManager {
    
    static var shared = NetworkManager()
    private let ratesUrlString = "https://api.nbp.pl/api/exchangerates/tables/A"
    
    init() {}
    
    func fetchRate(completion: @escaping (Result<NBPResponse, Error>) -> Void) {
        let request = URLRequest(url: URL(string: ratesUrlString)!)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            guard let nbpResponse = try? JSONDecoder().decode(NBPResponse.self, from: data) else { return }
            print(nbpResponse.rates[0].code)
            completion(.success(nbpResponse))
        }.resume()
    }
}
