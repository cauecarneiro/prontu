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
    
    private var userEnableAuthentication: Bool {
        get {
            UserDefaults.standard.bool(forKey: UserDefaultsKeys.userEnableAuthentication)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.userEnableAuthentication)
        }
    }
    
    private let authenticationService: AppLockValidatorService
    
    init(databaseService: DatabaseService, authenticationService: AppLockValidatorService) {
        self.selectedTab = .agenda
        self.agendaFlowCoordinator = AgendaFlowCoordinator(databaseService: databaseService)
        self.registerFlowCoordinator = RegisterFlowCoordinator()
        self.appointmentReportCoordinator = AppointmentReportFlowCoordinator()
        self.authenticationService = authenticationService
        
        appState = UserDefaults.standard.bool(forKey: UserDefaultsKeys.userEnableAuthentication) ? .lock : .unlock
    }
    
    func authentication() async throws -> Bool {

        if userEnableAuthentication && authenticationService.validate() == .available {
            return try await authenticationService.authenticate()
        }
        
        throw NSErrorDomain(string: "Should not be called, because the user is not enabled or the lock is not available") as! any Error
    }
    
    func unlockApp() {
        appState = .unlock
    }
}
