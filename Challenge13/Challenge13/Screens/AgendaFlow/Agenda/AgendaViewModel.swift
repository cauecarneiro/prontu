//
//  AgendaViewModel.swift
//  Challenge13
//
//  Created by Caio Mandarino on 01/04/26.
//

import Combine

final class AgendaViewModel: ObservableObject {
    weak private var coordinator: (any AgendaCoordinateProtocol)?
    
    init(coordinator: some AgendaFlowCoordinator) {
        self.coordinator = coordinator
    }
    
    func navigateToCreateAppointment() {
        coordinator?.navigateToCreateAppointment()
    }
    
    func navigateToAppointmentDetails(appointment: Appointment) {
        coordinator?.navigateToAppointmentDetails(appointment: appointment)
    }
}
