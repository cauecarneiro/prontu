//
//  PreviewFuncs.swift
//  Challenge13
//
//  Created by Caio Mandarino on 08/04/26.
//

import Foundation
import SwiftData

func makeAgendaFlowCoordinator() -> AgendaFlowCoordinator {
    
    let container = try! ModelContainer(for: Client.self, Appointment.self, configurations: .init(isStoredInMemoryOnly: true))
    let context = ModelContext(container)
    let databaseService = DatabaseService(context: context)
    
    return AgendaFlowCoordinator(
        factory: .init(databaseService: databaseService, screenMonitorService: .shared)
    )
}

func makeMainContext() -> ModelContext {
    try! ModelContainer(for: Client.self, Appointment.self, configurations: .init()).mainContext
}

func makeRegisterFlowDatabaseService() -> DatabaseService {
    let container = try! ModelContainer(for: Client.self, Appointment.self, configurations: .init(isStoredInMemoryOnly: true))
    return DatabaseService(context: ModelContext(container))
}

func makeRegisterFlowCoordinator() -> RegisterFlowCoordinator {
    RegisterFlowCoordinator(factory: .init(databaseService: makeRegisterFlowDatabaseService()))
}
