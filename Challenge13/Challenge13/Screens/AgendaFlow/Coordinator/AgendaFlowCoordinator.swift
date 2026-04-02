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
    
    @MainActor @ViewBuilder var rootView: some View { AgendaView(viewModel: .init(coordinator: self)) }
    
    @MainActor @ViewBuilder func coordinate(to route: AgendaFlowRouter) -> some View {
        switch route {
        case .createAppointment:
            CreateAppointmentView()
        case .editAppointment(let Appointment): // Possível que vai precisar passar para essa tela qual appointment deve ser editado
            EditCardAppointmentView()
        case .appointmentDetails(let Appointment): // Mesma coisa, passar para essa tela qual o appointment que deve ser mostrado
            AppointmentDetailsView(viewModel: .init(coordinator: self))
        }
    }
    
    func navigateTo(_ route: AgendaFlowRouter) {
        navigationController.push(router: route)
    }
    
    func dismiss() {
        navigationController.pop()
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
        navigateTo(.editAppointment(appointment))
    }
}
