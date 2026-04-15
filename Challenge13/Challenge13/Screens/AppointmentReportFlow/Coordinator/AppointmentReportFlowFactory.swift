//
//  AppointmentReportFlowFactory.swift
//  Challenge13
//
//  Created by Caio Mandarino on 14/04/26.
//

import Foundation

final class AppointmentReportFlowFactory {
    
    lazy var appointmentReportVM: AppointmentReportViewModel = .init(coordinator: coordinator)
    
    weak var coordinator: AppointmentReportFlowCoordinator?
    
    func makeAppointmentReportView() -> AppointmentReportView {
        AppointmentReportView(viewModel: appointmentReportVM)
    }
    
    func makeClientHistoryView() -> ClientHistoryView {
        ClientHistoryView()
    }
    
    func makeSearchChatbotView() -> SearchChatbotView {
        SearchChatbotView()
    }
}
