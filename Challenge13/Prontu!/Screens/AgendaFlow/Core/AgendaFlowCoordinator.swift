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
    private let factory: AgendaFlowFactory

    init(factory: AgendaFlowFactory) {
        self.factory = factory
        self.factory.coordinator = self
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
        case .appointmentDetails(let appointmentID): // TODO: Mesma coisa, passar para essa tela qual o appointment que deve ser mostrado
            factory.makeAppointmentDetailsView(appointmentID: appointmentID)
        case .selectedClient:
            factory.makeSelectedClientSheet()
        case .selectedClientForAppointmentDetails:
            factory.makeAppointmentDetailsSelectedClientSheet()
        case .generateEquipaments:
            factory.makeGenerateEquipamentSheet()
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
        navigateTo(.appointmentDetails(appointment.id))
    }
}

extension AgendaFlowCoordinator: AppointmentDetailsCoordinateProtocol {
    func dismissAppointmentDetails() {
        dismissNavigation()
    }

    func navigateToEditAppointment(appointment: Appointment) {
        presentTo(.editAppointment(appointment))
    }

    func presentSelectedClientDetails() {
        presentTo(.selectedClientForAppointmentDetails)
    }
}

extension AgendaFlowCoordinator: CreateAppointmentCoordinatorProtocol {
    func presentSelectedClient() {
        presentTo(.selectedClient)
    }

    func presentGenerateEquipamentSheet() {
        presentTo(.generateEquipaments)
    }


    func dismissCreateAppointment() {
        dismissNavigation()
    }
}

extension AgendaFlowCoordinator: CreateClientCoordinatorProtocol {
    func dismissCreateClient() {
        dismissPresentation()
    }
}
