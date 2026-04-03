//
//  MainTabViewModel.swift
//  Challenge13
//
//  Created by Caio Mandarino on 01/04/26.
//

import Combine

final class MainTabCoordinator: ObservableObject {
    @Published var selectedTab: TabItens = .agenda
    let agendaFlowCoordinator = AgendaFlowCoordinator()
    let registerFlowCoordinator = RegisterFlowCoordinator()
    let appointmentReportCoordinator = AppointmentReportFlowCoordinator()
}
