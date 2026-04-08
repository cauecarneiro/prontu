//
//  AgendaViewModel.swift
//  Challenge13
//
//  Created by Caio Mandarino on 01/04/26.
//

import Combine
import Foundation

final class AgendaViewModel: ObservableObject {
    weak private var coordinator: (any AgendaCoordinateProtocol)?
    private let databaseService: DatabaseService
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var appointments: [Appointment]
    
    init(coordinator: some AgendaCoordinateProtocol, databaseService: DatabaseService) {
        self.coordinator = coordinator
        self.databaseService = databaseService
        self.appointments = databaseService.getAllElements()
        
        observeAppointments()
    }
    
    func navigateToCreateAppointment() {
        coordinator?.navigateToCreateAppointment()
    }
    
    func navigateToAppointmentDetails(appointment: Appointment) {
        coordinator?.navigateToAppointmentDetails(appointment: appointment)
    }
    
}

extension AgendaViewModel {
    private func observeAppointments() {
        databaseService.databaseChangePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                self.appointments = self.databaseService.getAllElements()
            }
            .store(in: &cancellables)
    }
}
