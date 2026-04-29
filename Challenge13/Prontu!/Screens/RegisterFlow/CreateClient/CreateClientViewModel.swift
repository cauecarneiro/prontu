//
//  CreateClientViewModel.swift
//  Challenge13
//
//  Created by Cauê Carneiro on 21/04/26.
//

import Combine
import Foundation

@MainActor
final class CreateClientViewModel: ObservableObject {

    @Published var name: String = ""
    @Published var contactInfo: String = ""
    @Published var observations: String = ""

    var canSave: Bool { !name.trimmingCharacters(in: .whitespaces).isEmpty }

    private let databaseService: DatabaseService
    weak var coordinator: (any CreateClientCoordinatorProtocol)?

    init(databaseService: DatabaseService, coordinator: (any CreateClientCoordinatorProtocol)?) {
        self.databaseService = databaseService
        self.coordinator = coordinator
    }

    func applyImportedContact(_ contact: ImportContact) {
        name = contact.name
        contactInfo = contact.number
    }

    func save() {
        guard canSave else { return }
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        let trimmedContact = contactInfo.trimmingCharacters(in: .whitespaces)
        let trimmedObservations = observations.trimmingCharacters(in: .whitespaces)
        databaseService.add(element: Client(
            name: trimmedName,
            contactInfo: trimmedContact,
            observations: trimmedObservations.isEmpty ? nil : trimmedObservations
        ))
        coordinator?.dismissCreateClient()
        reset()
    }

    func dismiss() {
        coordinator?.dismissCreateClient()
        reset()
    }

    private func reset() {
        Task {
            await Task.yield()
            await MainActor.run {
                name = ""
                contactInfo = ""
                observations = ""
            }
        }
    }
}
