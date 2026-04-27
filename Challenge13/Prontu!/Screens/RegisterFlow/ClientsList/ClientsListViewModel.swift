//
//  ClientsListViewModel.swift
//  Challenge13
//
//  Created by Caio Mandarino on 01/04/26.
//

import Combine
import Foundation

final class ClientsListViewModel: ObservableObject {
    
    @Published var clients: [Client] = []
    @Published var search: String = ""
    @Published var searching: Bool = false
    
    weak var coordinator: (any ClientListCoordinatorProtocol)?
    private let databaseService: DatabaseService
    private var cancellables: Set<AnyCancellable> = []
    
    init(coordinator: (any ClientListCoordinatorProtocol)?, databaseService: DatabaseService) {
        self.coordinator = coordinator
        self.databaseService = databaseService
        self.clients = databaseService.getAllElements()
        
        observableDatabase()
    }
    
    //FILTRO
    var filteredClients: [Client] {
        if search.isEmpty {
            return clients
        } else {
            return clients.filter {
                $0.name.localizedCaseInsensitiveContains(search)
            }
        }
    }
    
    //Lista plana
    var allClientsSorted: [Client]{
        groupedClients
            .keys.sorted()
            .flatMap { groupedClients[$0] ?? []}
    }
    
    //AGRUPAMENTO
    var groupedClients: [String: [Client]] {
        
        let grouped = Dictionary(grouping: filteredClients) { client in
            
            let firstLetter = client.name
                .trimmingCharacters(in: .whitespaces)
                .prefix(1)
            
            if let letter = firstLetter.first, letter.isLetter {
                return String(letter).uppercased()
            } else {
                return "#"
            }
        }
        
        return grouped.mapValues {
            $0.sorted { $0.name < $1.name }
        }
    }
    
    func presentCreateClient() {
        coordinator?.presentToCreateClient()
    }
    
    func navigateToEditClient(client: Client) {
        coordinator?.navigateToEditClient(client: client)
    }
    
    func observableDatabase() {
        databaseService.databaseChangePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                self.clients = self.databaseService.getAllElements()
            }
            .store(in: &cancellables)
    }
}
