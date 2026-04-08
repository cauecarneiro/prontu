//
//  Challenge13App.swift
//  Challenge13
//
//  Created by Caio Mandarino on 01/04/26.
//

import SwiftUI
import SwiftData

@main
struct Challenge13App: App {
    
    private let databaseService: DatabaseService
    private let container: ModelContainer
    
    init() {
        
        let container = try! ModelContainer(for: Appointment.self, Client.self, configurations: .init())
        self.container = container
        databaseService = .init(context: container.mainContext)
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView(coordinator: .init(databaseService: databaseService))
                .modelContainer(container)
        }
    }
}



