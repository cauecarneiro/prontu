//
//  MainTabViewModel.swift
//  Challenge13
//
//  Created by Caio Mandarino on 01/04/26.
//

import Combine

final class MainTabCoordinator: ObservableObject {
    @Published var selectedTab: TabItens
    let agendaFlowCoordinator: AgendaFlowCoordinator
    let registerFlowCoordinator: RegisterFlowCoordinator
    let appointmentReportCoordinator: AppointmentReportFlowCoordinator
    
    init(databaseService: DatabaseService) {
        self.selectedTab = .agenda
        self.agendaFlowCoordinator = AgendaFlowCoordinator(databaseService: databaseService)
        self.registerFlowCoordinator = RegisterFlowCoordinator()
        self.appointmentReportCoordinator = AppointmentReportFlowCoordinator()
    }
}
