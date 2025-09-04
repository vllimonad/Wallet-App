//
//  ExchangeRateService.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 04/09/2025.
//

import Foundation

final class ExchangeRateService {
    
    private let baseUrlString = "https://api.nbp.pl/api/exchangerates/rates/a"
    
    func fetchRates(_ currency: String, _ dateString: String) async throws -> Double {
        guard let url = URL(string: baseUrlString + "/\(currency)/" + dateString) else { return 1.0 }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let nbpResponse = try JSONDecoder().decode(NBPResponse.self, from: data)
        
        return nbpResponse.rates[0].mid
    }
}
