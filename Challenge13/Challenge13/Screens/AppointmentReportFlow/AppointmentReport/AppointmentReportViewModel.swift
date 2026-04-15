//
//  AppointmentReportViewModel.swift
//  Challenge13
//
//  Created by Caio Mandarino on 01/04/26.
//

import Combine
import Foundation

final class AppointmentReportViewModel: ObservableObject {
    weak private var coordinator: (any AppointmentReportCoordinatorProtocol)?
    private var databaseService: DatabaseService
    
    private var appointments: [Appointment]
    
    private var cancelables: Set<AnyCancellable> = []
    
    init(coordinator: (any AppointmentReportCoordinatorProtocol)?, databaseService: DatabaseService) {
        self.coordinator = coordinator
        self.databaseService = databaseService
        self.appointments = databaseService.getAllElements()
        
        observableDatabase()
    }
    
    func navigateToClientDetails(client: Client) {
        coordinator?.navigateToClientHistory(client: client, appointments: []) // TODO: Filtrar pelo client quais os appointments
    }
    
    func presentToChatbot() {
        coordinator?.presentSearchChatbot(appointments: appointments)
    }
    
    private func observableDatabase() {
        databaseService.databaseChangePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                self.appointments = databaseService.getAllElements()
            }
            .store(in: &cancelables)
        
    }
}
