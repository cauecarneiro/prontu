//
//  RegisterFlowCoordinator.swift
//  Challenge13
//
//  Created by Caio Mandarino on 03/04/26.
//

import SwiftUI

final class RegisterFlowCoordinator: Coordinator  {
 
    var navigationController: NavigationController = .init()
    private let factory: RegisterFlowFactory
    
    init(factory: RegisterFlowFactory) {
        self.factory = factory
        self.factory.coordinator = self
    }
    
    @MainActor @ViewBuilder var rootView: some View { factory.makeClientsListView() }
    
    @MainActor @ViewBuilder func coordinate(to route: RegisterFlowRouter) -> some View {
        switch route {
        case .createClient:
            factory.makeCreateClientView()
        case .editClient(let client): // TODO: Possível precisar passar qual o client a ser editado
            factory.makeEditClientView()
        }
    }
    
    private func navigateTo(_ route: RegisterFlowRouter) {
        navigationController.push(router: route)
    }
    
    private func presentTo(_ route: RegisterFlowRouter) {
        navigationController.presentSheet(router: route)
    }
    
    private func dismissNavigation() {
        navigationController.pop()
    }
    
    private func dismissPresentation() {
        navigationController.dismissSheet()
    }
}

extension RegisterFlowCoordinator: ClientListCoordinatorProtocol  {
    func navigateToEditClient(client: Client) {
        navigateTo(.editClient(client))
    }
    
    func presentToCreateClient() {
        presentTo(.createClient)
    }
    
    
    
}
