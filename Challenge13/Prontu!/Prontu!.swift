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
    @Environment(\.scenePhase) var scenePhase: ScenePhase
    private let screenMonitor: ScreenMonitorService
    private let databaseService: DatabaseService
    private let container: ModelContainer
    
    init() {
        
        let container = try! ModelContainer(for: Appointment.self, Client.self, configurations: .init())
        container.mainContext.autosaveEnabled = false

        self.container = container
        databaseService = .init(context: container.mainContext)
        let settingsStore = SettingsStore.shared
        let coordinator = MainTabCoordinator(
            databaseService: databaseService,
            authenticationService: .init(),
            screenMonitor: .shared,
            settingsStore: settingsStore
        )
        _coordinator = .init(wrappedValue: coordinator)
        screenMonitor = .shared
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
        .onChange(of: scenePhase) { _, newValue in
            screenMonitor.updateScreen(screen: newValue)
        }
    }
}

