//
//  AgendaFlowCoordinator.swift
//  Challenge13
//
//  Created by Caio Mandarino on 01/04/26.
//

import Combine
import SwiftUI

final class AgendaFlowCoordinator: Coordinator {
    
    var navigationController: NavigationController = .init()
    private var factory: AgendaFlowFactory
    
    init(factory: AgendaFlowFactory) {
        self.factory = factory
        factory.coordinator = self
    }
    
    @MainActor @ViewBuilder var rootView: some View {
        factory.makeAgendaView()
    }
    
    @MainActor @ViewBuilder func coordinate(to route: AgendaFlowRouter) -> some View {
        switch route {
        case .createClient:
            factory.makeCreateClientView()
        case .createAppointment:
            factory.makeCreateAppointmentView()
        case .editAppointment(let appointment): // TODO: Possível que vai precisar passar para essa tela qual appointment deve ser editado
            factory.makeEditAppointment()
        case .appointmentDetails(let appointment): // TODO: Mesma coisa, passar para essa tela qual o appointment que deve ser mostrado
            factory.makeEditAppointment()
        }
    }
    
    private func navigateTo(_ route: AgendaFlowRouter) {
        navigationController.push(router: route)
    }
    
    private func presentTo(_ route: AgendaFlowRouter, onDismiss: (() -> Void)? = nil) {
        navigationController.presentSheet(router: route)
    }
    
    private func dismissNavigation() {
        navigationController.pop()
    }
    
    private func dismissPresentation() {
        navigationController.dismissSheet()
    }
}

extension AgendaFlowCoordinator: AgendaCoordinateProtocol {

    func navigateToCreateAppointment() {
        navigateTo(.createAppointment)
    }
    
    func navigateToAppointmentDetails(appointment: Appointment) {
        navigateTo(.appointmentDetails(appointment))
    }
    
    
}

extension AgendaFlowCoordinator: AppointmentDetailsCoordinateProtocol {
    func navigateToEditAppointment(appointment: Appointment) {
        presentTo(.editAppointment(appointment))
    }
}

extension AgendaFlowCoordinator: CreateAppointmentCoordinatorProtocol {
    func presentCreateClient() {
        presentTo(.createClient)
    }
}
