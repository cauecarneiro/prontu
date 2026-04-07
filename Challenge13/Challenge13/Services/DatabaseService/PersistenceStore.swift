//
//  DatabaseService.swift
//  Challenge13
//
//  Created by Caio Mandarino on 03/04/26.
//

import SwiftData

@ModelActor
actor PersistenceStore {
    
    init(container: ModelContainer) {
        let context = ModelContext(container)
        let executor = DefaultSerialModelExecutor(modelContext: context)
        self.modelExecutor = executor
        self.modelContainer = container
    }
        
    func insert<T: PersistentModel>(_ model: T) {
        modelContext.insert(model)
    }
    
    func delete<T: PersistentModel>(_ model: T) {
        modelContext.delete(model)
    }
    
    func save() throws {
        guard modelContext.hasChanges else { return }
        try modelContext.save()
    }
    
    func rollback() {
        modelContext.rollback()
    }
        
    func fetch<T: PersistentModel>(
        _ descriptor: FetchDescriptor<T>
    ) throws -> [T] {
        try modelContext.fetch(descriptor)
    }

}
