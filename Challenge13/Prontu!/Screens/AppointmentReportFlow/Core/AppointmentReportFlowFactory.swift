//
//  AppointmentReportFlowFactory.swift
//  Challenge13
//
//  Created by Caio Mandarino on 14/04/26.
//

import Foundation

final class AppointmentReportFlowFactory {
    
    private var databaseService: DatabaseService
    
    private lazy var appointmentReportVM: AppointmentReportViewModel = .init(
        coordinator: coordinator,
        databaseService: databaseService
    )
        
    weak var coordinator: AppointmentReportFlowCoordinator?
    
    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }
    
    func makeAppointmentReportView() -> AppointmentReportView {
        AppointmentReportView(viewModel: appointmentReportVM)
    }
    
    func makeClientHistoryView() -> ClientHistoryView {
        ClientHistoryView()
    }
    
    func makeSearchChatbotView(appointments: [Appointment]) -> SearchChatbotView {
        SearchChatbotView(viewModel: .init(engine: .init(provider: databaseService, classifier: .init())))
    }
}
