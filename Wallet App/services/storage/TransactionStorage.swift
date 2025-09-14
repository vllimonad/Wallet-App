//
//  Storage.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 23/08/2025.
//

import Foundation
import SwiftData

final class TransactionStorage {
    
    private let modelContainer: ModelContainer
    
    init(_ modelContainer: ModelContainer? = nil) {
        do {
            if let modelContainer = modelContainer {
                self.modelContainer = modelContainer
            } else {
                self.modelContainer = try ModelContainer(for: TransactionModel.self)
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    @MainActor
    func getModels() -> [TransactionModel] {
        let sortDescriptor = SortDescriptor<TransactionModel>(\.date, order: .reverse)
        let descriptor = FetchDescriptor<TransactionModel>(sortBy: [sortDescriptor])
        return (try? modelContainer.mainContext.fetch(descriptor)) ?? []
    }
    
    @MainActor
    func addModel(_ model: TransactionModel) throws {
        modelContainer.mainContext.insert(model)
        try saveContext()
    }
    
    @MainActor
    func deleteModel(_ model: TransactionModel) throws {
        modelContainer.mainContext.delete(model)
        try saveContext()
    }
    
    @MainActor
    func saveContext() throws {
        try modelContainer.mainContext.save()
    }
}
