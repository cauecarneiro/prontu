//
//  AppointmentDetailsViewModel.swift
//  Challenge13
//
//  Created by Caio Mandarino on 01/04/26.
//

import Combine

final class AppointmentDetailsViewModel: ObservableObject {
    weak private var coordinator: (any AppointmentDetailsCoordinateProtocol)?
    
    init(coordinator: (any AppointmentDetailsCoordinateProtocol)?) {
        self.coordinator = coordinator
    }
    
    func navigateToEditAppointment(appointment: Appointment) {
        coordinator?.navigateToEditAppointment(appointment: appointment)
    }
}
