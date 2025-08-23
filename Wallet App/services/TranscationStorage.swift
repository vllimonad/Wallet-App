//
//  Storage.swift
//  Wallet App
//
//  Created by Vlad Klunduk on 23/08/2025.
//

import Foundation
import SwiftData

final class TranscationStorage {
    
    private let modelContainer: ModelContainer
    
    init() {
        do {
            self.modelContainer = try ModelContainer(for: TransactionModel.self)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    @MainActor
    public func getModels() -> [TransactionModel] {
        let sortDescriptor = SortDescriptor<TransactionModel>(\.date, order: .reverse)
        let descriptor = FetchDescriptor<TransactionModel>(sortBy: [sortDescriptor])
        return (try? modelContainer.mainContext.fetch(descriptor)) ?? []
    }
    
    @MainActor
    public func addModel(_ model: TransactionModel) throws {
        modelContainer.mainContext.insert(model)
        try saveContext()
    }
    
    @MainActor
    public func deleteModel(_ model: TransactionModel) throws {
        modelContainer.mainContext.delete(model)
        try saveContext()
    }
    
    @MainActor
    public func saveContext() throws {
        try modelContainer.mainContext.save()
    }
}
