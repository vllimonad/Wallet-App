//
//  Rate.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 10/09/2023.
//

import Foundation

struct Rate: Codable {
    let date: String
    let eur: [String: Double]
}
