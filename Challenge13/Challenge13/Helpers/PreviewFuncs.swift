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
    
    return AgendaFlowCoordinator(databaseService: databaseService)
}

func makeMainContext() -> ModelContext {
    try! ModelContainer(for: Client.self, Appointment.self, configurations: .init()).mainContext
}
