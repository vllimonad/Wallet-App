//
//  TransactionDataSource.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 30/08/2025.
//

import Foundation
import DeveloperToolsSupport

final class TransactionDataSource {
    
    public static func getCategoryImageResource(_ category: TransactionCategory) -> ImageResource {
        let imageResorce: ImageResource
        
        switch category {
        case .food:
            imageResorce = .categoryFood
        case .communication:
            imageResorce = .categoryCommunication
        case .entertainment:
            imageResorce = .categoryEntertainment
        case .financialExpenses:
            imageResorce = .categoryFinancialExpenses
        case .housing:
            imageResorce = .categoryHousing
        case .shopping:
            imageResorce = .categoryShopping
        case .transportation:
            imageResorce = .categoryTransportation
        }
        
        return imageResorce
    }
}
