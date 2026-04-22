//
//  RegisterFlowFactory.swift
//  Challenge13
//
//  Created by Caio Mandarino on 14/04/26.
//

import Foundation

final class RegisterFlowFactory {

    weak var coordinator: RegisterFlowCoordinator?
    private let databaseService: DatabaseService

    private lazy var clientListVM: ClientsListViewModel = .init(coordinator: coordinator)
    private lazy var createClientVM: CreateClientViewModel = .init(databaseService: databaseService, coordinator: coordinator)

    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }

    func makeClientsListView() -> ClientsListView {
        ClientsListView(viewModel: clientListVM)
    }

    func makeCreateClientView() -> CreateClientView {
        CreateClientView(viewModel: createClientVM)
    }

    func makeEditClientView() -> EditClientView {
        EditClientView()
    }
}
