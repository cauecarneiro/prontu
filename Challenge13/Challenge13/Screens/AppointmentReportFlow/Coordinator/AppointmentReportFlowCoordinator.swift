//
//  AppointmentReportFlowCoordinator.swift
//  Challenge13
//
//  Created by Caio Mandarino on 03/04/26.
//

import SwiftUI

final class AppointmentReportFlowCoordinator: Coordinator {
    
    var navigationController: NavigationController = .init()

    @MainActor @ViewBuilder var rootView: some View { AppointmentReportView(viewModel: .init(coordinator: self)) }
    
    @MainActor @ViewBuilder func coordinate(to route: AppointmentReportFlowRouter) -> some View {
        switch route {
        case .clientHistory(let currentClient, let clientAppointments): // TODO: ver se faz sentido
            ClientHistoryView()
        case .searchChatBot:
            SearchChatbotView()
        }
    }
    
    private func navigateTo(_ route: AppointmentReportFlowRouter) {
        navigationController.push(router: route)
    }
    
    private func presentTo(_ route: AppointmentReportFlowRouter) {
        navigationController.presentSheet(router: route)
    }
    
    private func dismissNavigation() {
        navigationController.pop()
    }
    
    private func dismissPresentation() {
        navigationController.dismissSheet()
    }
}

extension AppointmentReportFlowCoordinator: AppointmentReportCoordinatorProtocol {
    func presentSearchChatbot() {
        presentTo(.searchChatBot)
    }
    
    func navigateToClientHistory(client: Client, appointments: [Appointment]) {
        navigateTo(.clientHistory(client, appointments))
    }
    
    
}
