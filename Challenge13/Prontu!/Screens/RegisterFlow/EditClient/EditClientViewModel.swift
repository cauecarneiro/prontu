//
//  EditClientViewModel.swift
//  Challenge13
//
//  Created by Caio Mandarino on 01/04/26.
//

import Combine
import Foundation

protocol EditClientCoordinatorProtocol: AnyObject {
    func dismissEditClient()
}

@MainActor
final class EditClientViewModel: ObservableObject {

    let client: Client
    @Published var name: String
    @Published var contactInfo: String
    @Published var isEditing: Bool = false

    var canSave: Bool { !name.trimmingCharacters(in: .whitespaces).isEmpty }

    var sortedAppointments: [Appointment] {
        client.appointments
            .filter { $0.status != .blocked && $0.status != .cancelled }
            .sorted { $0.startDate > $1.startDate }
    }

    private let databaseService: DatabaseService
    weak var coordinator: (any EditClientCoordinatorProtocol)?

    init(client: Client, databaseService: DatabaseService, coordinator: (any EditClientCoordinatorProtocol)?) {
        self.client = client
        self.name = client.name
        self.contactInfo = client.contactInfo
        self.databaseService = databaseService
        self.coordinator = coordinator
    }

    func save() {
        guard canSave else { return }
        client.name = name.trimmingCharacters(in: .whitespaces)
        client.contactInfo = contactInfo.trimmingCharacters(in: .whitespaces)
        databaseService.update(element: client)
        isEditing = false
    }

    func cancelEdit() {
        name = client.name
        contactInfo = client.contactInfo
        isEditing = false
    }

    func dismiss() {
        coordinator?.dismissEditClient()
    }
}
