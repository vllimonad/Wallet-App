//
//  ExchangeRateServiceProtocol.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 14/09/2025.
//

import Foundation

protocol ExchangeRateServiceProtocol {
    
    @MainActor
    func fetchRates(_ currency: String, _ dateString: String) async throws -> Double
}
