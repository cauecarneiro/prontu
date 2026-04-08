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
        static var register: String { "Register" }
        static var report: String { "Report" }
    }
    
    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            Tab(StringValues.agenda, systemImage: "calendar", value: .agenda) {
                CoordinateView(coordinator: coordinator.agendaFlowCoordinator)
            }
            
            Tab(StringValues.register, systemImage: "person", value: .register) {
                CoordinateView(coordinator: coordinator.registerFlowCoordinator)
            }
            
            Tab(StringValues.report, systemImage: "calendar", value: .report) {
                CoordinateView(coordinator: coordinator.appointmentReportCoordinator)
            }
        }
    }
}

#Preview {
    MainTabView(coordinator: .init(databaseService: .init(context: makeMainContext())))
}
