//
//  AgendaFlowFactory.swift
//  Challenge13
//
//  Created by Caio Mandarino on 14/04/26.
//

import Foundation

final class AgendaFlowFactory {
    
    private let databaseService: DatabaseService
    private let screenMonitorService: ScreenMonitorService
    weak var coordinator: AgendaFlowCoordinator?
    
    private lazy var agendaVM: AgendaViewModel = AgendaViewModel(
        coordinator: coordinator,
        databaseService: databaseService,
        screenMonitorService: screenMonitorService
    )
    
    private lazy var createAppointmentVM: CreateAppointmentViewModel = CreateAppointmentViewModel(
        coordinator: coordinator
    )
    
    private lazy var appointmentDetailsVM: AppointmentDetailsViewModel = AppointmentDetailsViewModel(
        coordinator: coordinator
    )
    
    init(databaseService: DatabaseService, screenMonitorService: ScreenMonitorService) {
        self.databaseService = databaseService
        self.screenMonitorService = screenMonitorService
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
