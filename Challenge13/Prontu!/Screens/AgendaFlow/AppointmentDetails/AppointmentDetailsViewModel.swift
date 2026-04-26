//
//  AppointmentDetailsViewModel.swift
//  Challenge13
//
//  Created by Caio Mandarino on 01/04/26.
//

import Combine
import Foundation

@MainActor
final class AppointmentDetailsViewModel: ObservableObject {
    
    @Published var currentStatus: AppointmentStatus
    
    weak private var coordinator: (any AppointmentDetailsCoordinateProtocol)?
    let appointment: Appointment
    private var cancellables: Set<AnyCancellable> = []

    var client: Client? {
        appointment.client
    }

    var dateText: String {
        appointment.startDate.detailsDayText
    }

    var timeText: String {
        "\(appointment.startDate.detailsHourText) - \(appointment.endDate.detailsHourText)"
    }
    
    var durationText: String {
        appointment.startDate.distance(to: appointment.endDate).formattedDuration
    }

    init(
        coordinator: (any AppointmentDetailsCoordinateProtocol)?,
        appointment: Appointment
    ) {
        self.coordinator = coordinator
        self.appointment = appointment
        self.currentStatus = appointment.status
        
        observableStatus()
    }

    func navigateToEditAppointment() {
        coordinator?.navigateToEditAppointment(appointment: appointment)
    }
    
    func observableStatus() {
        $currentStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                guard let self else { return }
                self.appointment.status = status
            }
            .store(in: &cancellables)
    }
    
    func onClientClick() {
        
    }
}
