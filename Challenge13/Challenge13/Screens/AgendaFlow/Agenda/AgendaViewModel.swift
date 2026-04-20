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
    @Published var selectedDate: Date
    @Published var agendaViewID: UUID = .init()
    
    var formatterDate: String {
        selectedDate.formatterRow()
    }

    var dailyAppointments: [Appointment] {
        appointments.filter {
            Calendar.current.isDate($0.startDate, inSameDayAs: selectedDate) &&
            $0.status != .cancelled
        }
        .sorted(by: { $0.startDate < $1.startDate })
    }
    
    init(
        coordinator: (any AgendaCoordinateProtocol)?,
        databaseService: DatabaseService,
        screenMonitorService: ScreenMonitorService,
    ) {
        self.coordinator = coordinator
        self.databaseService = databaseService
        self.appointments = databaseService.getAllElements()
        self.selectedDate = .now
        
        observeScreenPhase(screenMonitorService: screenMonitorService)
        observeAppointments()
    }
    
    func addedAppointment() { // TODO: Remover
        let appointments = Appointment.mockData()
        for appointment in appointments {
            databaseService.add(element: appointment)
        }
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
    
    private func observeScreenPhase(screenMonitorService: ScreenMonitorService) {
        screenMonitorService.sceneDidUpdate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] screen in
                guard let self else { return }
                if screen == .active {
                    agendaViewID = UUID()
                }
            }
            .store(in: &cancellables)
    }
}
