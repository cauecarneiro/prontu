//
//  RegisterFlowFactory.swift
//  Challenge13
//
//  Created by Caio Mandarino on 14/04/26.
//

import Foundation

final class RegisterFlowFactory {
    
    weak var coordinator: RegisterFlowCoordinator?

    private lazy var clientListVM: ClientsListViewModel = .init(coordinator: coordinator)
    
    func makeClientsListView() -> ClientsListView {
        ClientsListView(viewModel: clientListVM)
    }
    
    func makeCreateClientView() -> CreateClientView {
        CreateClientView()
    }
    
    func makeEditClientView() -> EditClientView {
        EditClientView()
    }
}
