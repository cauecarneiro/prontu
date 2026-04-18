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
    private let settingsStore: SettingsStore // TODO: Remover
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var appointments: [Appointment]
    @Published var selectedDate: Date
    
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
    
    var userAuthenticated: Bool { // TODO: Remover
        get {
            settingsStore.isAuthenticationEnabled
        }
        set {
            let authenticationService = AppLockValidatorService()
            
            if newValue == false {
                settingsStore.setAuthenticationEnabled(newValue)
                return
            }
            
            if authenticationService.validate() == .available {
                settingsStore.setAuthenticationEnabled(newValue)
            }
        }
    }
    
    init(
        coordinator: (any AgendaCoordinateProtocol)?,
        databaseService: DatabaseService,
        settingsStore: SettingsStore
    ) {
        self.coordinator = coordinator
        self.databaseService = databaseService
        self.settingsStore = settingsStore
        self.appointments = databaseService.getAllElements()
        self.selectedDate = .now
        
        observeAppointments()
    }
    
    func addedAppointment() {
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
}
