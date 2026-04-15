//
//  AppointmentReportViewModel.swift
//  Challenge13
//
//  Created by Caio Mandarino on 01/04/26.
//

import Combine

final class AppointmentReportViewModel: ObservableObject {
    weak private var coordinator: (any AppointmentReportCoordinatorProtocol)?
    
    init(coordinator: (any AppointmentReportCoordinatorProtocol)?) {
        self.coordinator = coordinator
    }
    
    func navigateToClientDetails(client: Client) {
        coordinator?.navigateToClientHistory(client: client, appointments: []) // TODO: Filtrar pelo client quais os appointments
    }
    
    func presentToChatbot() {
        coordinator?.presentSearchChatbot()
    }
}
