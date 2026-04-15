//
//  AgendaFlowFactory.swift
//  Challenge13
//
//  Created by Caio Mandarino on 14/04/26.
//

import Foundation

final class AgendaFlowFactory {
    
    private let databaseService: DatabaseService
    private let settingsStore: SettingsStore
    weak var coordinator: AgendaFlowCoordinator?
    
    lazy var agendaVM: AgendaViewModel = AgendaViewModel(
        coordinator: coordinator,
        databaseService: databaseService,
        settingsStore: settingsStore
    )
    
    lazy var createAppointmentVM: CreateAppointmentViewModel = CreateAppointmentViewModel(
        coordinator: coordinator
    )
    
    lazy var appointmentDetailsVM: AppointmentDetailsViewModel = AppointmentDetailsViewModel(
        coordinator: coordinator
    )
    
    init(databaseService: DatabaseService, settingsStore: SettingsStore) {
        self.databaseService = databaseService
        self.settingsStore = settingsStore
    }
    
    func makeAgendaView() -> AgendaView {
        AgendaView(viewModel: agendaVM)
    }
    
    func makeCreateClientView() -> CreateClientView {
        CreateClientView()
    }
    
    func makeCreateAppointmentView() -> CreateAppointmentView {
        CreateAppointmentView(viewModel: createAppointmentVM)
    }
    
    func makeEditAppointment() -> EditCardAppointmentView {
        EditCardAppointmentView()
    }
    
    func makeAppointmentDetailsView() -> AppointmentDetailsView {
        AppointmentDetailsView(viewModel: appointmentDetailsVM)
    }
}
