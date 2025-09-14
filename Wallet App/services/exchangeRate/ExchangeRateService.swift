//
//  ExchangeRateService.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 04/09/2025.
//

import Foundation

final class ExchangeRateService: ExchangeRateServiceProtocol {
    
    private let baseUrlString = "https://api.nbp.pl/api/exchangerates/rates/a"
    
    private let exchangeRateClient: ExchangeRateClient
    
    init(client: ExchangeRateClient = URLSession.shared) {
        self.exchangeRateClient = client
    }
    
    @MainActor
    func fetchRates(_ currency: String, _ dateString: String) async throws -> Double {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.nbp.pl"
        components.path = "/api/exchangerates/rates/a/\(currency)/\(dateString)"

        guard
            let url = components.url,
            currency.count == 3
        else { return 1.0 }
        
        let (data, _) = try await exchangeRateClient.data(from: url)
        
        let nbpResponse = try JSONDecoder().decode(NBPResponse.self, from: data)
        
        return nbpResponse.rates[0].mid
    }
}
