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
    @Published var observation: String
    
    weak private var coordinator: (any AppointmentDetailsCoordinateProtocol)?
    private let databaseService: DatabaseService
    let appointment: Appointment

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
    
    var result: String {
        appointment.equipment ?? ""
    }

    init(
        coordinator: (any AppointmentDetailsCoordinateProtocol)?,
        databaseService: DatabaseService,
        appointment: Appointment
    ) {
        self.coordinator = coordinator
        self.databaseService = databaseService
        self.appointment = appointment
        self.currentStatus = appointment.status
        self.observation = appointment.notes ?? ""
    }

    func navigateToEditAppointment() {
        coordinator?.navigateToEditAppointment(appointment: appointment)
    }
    
    func onClientClick() {
        
    }
    
    func dismiss() { // TODO: Implement save
        if appointment.status != currentStatus {
            appointment.status = currentStatus
            databaseService.save()
        }
        
        coordinator?.dismissAppointmentDetails()
    }
}
