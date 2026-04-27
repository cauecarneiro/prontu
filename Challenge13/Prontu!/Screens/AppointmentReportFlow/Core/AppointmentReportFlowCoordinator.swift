//
//  AppointmentReportFlowCoordinator.swift
//  Challenge13
//
//  Created by Caio Mandarino on 03/04/26.
//

import SwiftUI

final class AppointmentReportFlowCoordinator: Coordinator {
    
    var navigationController: NavigationController = .init()
    private let factory: AppointmentReportFlowFactory

    init(factory: AppointmentReportFlowFactory) {
        self.factory = factory
        self.factory.coordinator = self
    }
    
    @MainActor @ViewBuilder var rootView: some View { factory.makeAppointmentReportView() }
    
    @MainActor @ViewBuilder func coordinate(to route: AppointmentReportFlowRouter) -> some View {
        switch route {
        case .clientHistory(let currentClient, let clientAppointments):
            factory.makeClientHistoryView()
        case .searchChatBot(let appointment):
            factory.makeSearchChatbotView(appointments: appointment)
        case .preferences:
            factory.makePreferencesView()
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
    func presentSearchChatbot(appointments: [Appointment]) {
        presentTo(.searchChatBot(appointments))
    }

    func navigateToClientHistory(client: Client, appointments: [Appointment]) {
        navigateTo(.clientHistory(client, appointments))
    }

    func navigateToPreferences() {
        navigateTo(.preferences)
    }
}

extension AppointmentReportFlowCoordinator: SearchChatBotCoordinatorProtocol {
    func dismissSearchChatBot() {
        dismissPresentation()
    }
    
}
