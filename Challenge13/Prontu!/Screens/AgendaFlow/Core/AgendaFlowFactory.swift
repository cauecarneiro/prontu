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
        coordinator: coordinator, databaseService: databaseService
    )
    
    private lazy var createClientVM: CreateClientViewModel = CreateClientViewModel(
        databaseService: databaseService,
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
        CreateClientView(viewModel: createClientVM)
    }
    
    func makeCreateAppointmentView() -> CreateAppointmentView {
        CreateAppointmentView(viewModel: createAppointmentVM)
    }
    
    func makeEditAppointment() -> EditCardAppointmentView {
        EditCardAppointmentView()
    }
    
    func makeAppointmentDetailsView(appointment: Appointment) -> AppointmentDetailsView {
        AppointmentDetailsView(viewModel: .init(coordinator: coordinator, appointment: appointment))
    }
    
    func makeSelectedClientSheet() -> SelectClientSheet {
        SelectClientSheet(viewModel: createAppointmentVM)
    }
    
    func makeGenerateEquipamentSheet() -> GenerateEquipamentSheet {
        GenerateEquipamentSheet(viewModel: createAppointmentVM)
    }
}

