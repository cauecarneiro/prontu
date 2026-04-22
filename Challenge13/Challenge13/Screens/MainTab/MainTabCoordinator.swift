//
//  MainTabViewModel.swift
//  Challenge13
//
//  Created by Caio Mandarino on 01/04/26.
//

import Combine
import Foundation

final class MainTabCoordinator: ObservableObject {
    @Published var selectedTab: TabItens
    @Published var appState: AppState
    
    let agendaFlowCoordinator: AgendaFlowCoordinator
    let registerFlowCoordinator: RegisterFlowCoordinator
    let appointmentReportCoordinator: AppointmentReportFlowCoordinator
    
    private let authenticationService: AppLockValidatorService
    private let screenMonitor: ScreenMonitorService
    private let settingsStore: SettingsStore
    
    private var settingsObservation: AnyCancellable?
    private var scenePhaseObservation: AnyCancellable?
    
    private var isRunningAuthentication: Bool = false
    
    init(
        databaseService: DatabaseService,
        authenticationService: AppLockValidatorService,
        screenMonitor: ScreenMonitorService,
        settingsStore: SettingsStore
    ) {
        self.selectedTab = .agenda
        
        self.agendaFlowCoordinator = AgendaFlowCoordinator(
            factory: .init(databaseService: databaseService, screenMonitorService: screenMonitor)
        )
        
        self.registerFlowCoordinator = RegisterFlowCoordinator(factory: .init(databaseService: databaseService))
        self.appointmentReportCoordinator = AppointmentReportFlowCoordinator(
            factory: .init(databaseService: databaseService)
        )
        self.authenticationService = authenticationService
        self.screenMonitor = screenMonitor
        self.settingsStore = settingsStore
        
        appState = settingsStore.isAuthenticationEnabled ? .lock : .unlock
        
        observeAuthenticationSetting()
        configureScenePhaseObservation(isEnabled: settingsStore.isAuthenticationEnabled)
    }
    
    func authentication() async throws {
        if isRunningAuthentication { return }
        
        isRunningAuthentication = true
        defer { isRunningAuthentication = false }
        
        guard settingsStore.isAuthenticationEnabled && authenticationService.validate() == .available else {
            throw NSErrorDomain(string: "Should not be called, because the user is not enabled or the lock is not available") as! any Error
        }
        
        guard try await authenticationService.authenticate() else {
            throw NSErrorDomain(string: "Authentication failed") as! any Error
        }
            
        unlockApp()
    }
    
    private func unlockApp() {
        appState = .unlock
    }
    
    private func observeAuthenticationSetting() {
        settingsObservation = NotificationCenter.default.publisher(for: .authenticationSettingDidChange)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notification in
                guard let self else { return }
                
                let isAuthenticationEnabled =
                    notification.userInfo?[SettingsStoreUserInfoKey.isAuthenticationEnabled] as? Bool
                    ?? settingsStore.isAuthenticationEnabled
                
                configureScenePhaseObservation(isEnabled: isAuthenticationEnabled)
            }
    }
    
    private func configureScenePhaseObservation(isEnabled: Bool) {
        scenePhaseObservation?.cancel()
        scenePhaseObservation = nil
        
        guard isEnabled else { return }
        
        scenePhaseObservation = screenMonitor.sceneDidUpdate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] sceneState in
                guard let self, sceneState != .active else { return }
                appState = .lock
            }
    }
}
