//
//  NBPResponse.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 08/09/2024.
//

import Foundation

struct NBPResponse: Codable {
    
    struct Rate: Codable {
        let mid: Double
    }
    
    let rates: [Rate]
}
