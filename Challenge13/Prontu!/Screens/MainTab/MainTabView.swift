//
//  MainTabView.swift
//  Challenge13
//
//  Created by Caio Mandarino on 01/04/26.
//

import SwiftUI

struct MainTabView: View {
    
    @ObservedObject var coordinator: MainTabCoordinator
    
    struct StringValues {
        static var agenda: String { "Agenda" }
        static var register: String { "Clientes" }
        static var report: String { "Relatórios" }
    }
    
    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            Tab(StringValues.agenda, systemImage: "calendar", value: .agenda) {
                CoordinateView(coordinator: coordinator.agendaFlowCoordinator)
            }
            
            Tab(StringValues.register, systemImage: "person.2.fill", value: .register) {
                CoordinateView(coordinator: coordinator.registerFlowCoordinator)
            }
            
            Tab(StringValues.report, systemImage: "chart.bar.xaxis", value: .report) {
                CoordinateView(coordinator: coordinator.appointmentReportCoordinator)
            }
        }
        .tint(GlobalConfiguration.primaryBlue)
    }
}

#Preview {
    MainTabView(
        coordinator: .init(
            databaseService: .init(context: makeMainContext()),
            authenticationService: .init(),
            screenMonitor: .shared,
            settingsStore: .shared
        )
    )
}
