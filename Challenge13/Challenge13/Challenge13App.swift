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
    
    @StateObject var coordinator: MainTabCoordinator
    private let databaseService: DatabaseService
    private let container: ModelContainer
    
    init() {
        
        let container = try! ModelContainer(for: Appointment.self, Client.self, configurations: .init())
        self.container = container
        databaseService = .init(context: container.mainContext)
        let coordinator = MainTabCoordinator(databaseService: databaseService, authenticationService: .init())
        _coordinator = .init(wrappedValue: coordinator)
    }
    
    var body: some Scene {
        WindowGroup {
            switch coordinator.appState {
            case .unlock:
                MainTabView(coordinator: coordinator)
                    .modelContainer(container)
            case .lock:
                LockScreenView(coordinator: coordinator)
            }
            
        }
    }
}



