//
//  CreateAppointmentViewModel.swift
//  Challenge13
//
//  Created by Caio Mandarino on 01/04/26.
//

import Combine

final class CreateAppointmentViewModel: ObservableObject {
    
    weak private var coordinator: (any CreateAppointmentCoordinatorProtocol)?
    
    init(coordinator: some CreateAppointmentCoordinatorProtocol) {
        self.coordinator = coordinator
    }
    
    func presentCreateClient() {
        coordinator?.presentCreateClient()
    }
}
