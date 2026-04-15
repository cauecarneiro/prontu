//
//  ClientsListViewModel.swift
//  Challenge13
//
//  Created by Caio Mandarino on 01/04/26.
//

import Combine

final class ClientsListViewModel: ObservableObject {
    weak var coordinator: (any ClientListCoordinatorProtocol)?
    
    init(coordinator: (any ClientListCoordinatorProtocol)?) {
        self.coordinator = coordinator
    }
    
    func presentCreateClient() {
        coordinator?.presentToCreateClient()
    }
    
    func navigateToEditClient(client: Client) {
        coordinator?.navigateToEditClient(client: client)
    }
}
