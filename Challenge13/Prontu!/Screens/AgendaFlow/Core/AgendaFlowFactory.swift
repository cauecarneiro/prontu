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
    
    private var detailsAppointmentVM: AppointmentDetailsViewModel?
    
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

    func makeAppointmentDetailsView(appointmentID: UUID) -> AppointmentDetailsView {
        
        if detailsAppointmentVM?.appointment.id != appointmentID {
            
            guard let appointment = databaseService.getAppointment(id: appointmentID) else {
                fatalError("Error: appointment not found with id \(appointmentID)")
            }
            
            detailsAppointmentVM = AppointmentDetailsViewModel(
                coordinator: coordinator,
                appointment: appointment
            )
        }
        
        return AppointmentDetailsView(viewModel: detailsAppointmentVM!)
    }
    
    func makeSelectedClientSheet() -> SelectClientSheet {
        SelectClientSheet(viewModel: createAppointmentVM)
    }
    
    func makeGenerateEquipamentSheet() -> GenerateEquipamentSheet {
        GenerateEquipamentSheet(viewModel: createAppointmentVM)
    }
}
