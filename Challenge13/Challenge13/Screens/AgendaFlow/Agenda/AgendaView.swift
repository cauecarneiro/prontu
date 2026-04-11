//
//  AgendaView.swift
//  Challenge13
//
//  Created by Caio Mandarino on 01/04/26.
//

import SwiftUI

struct AgendaView: View {
    
    @ObservedObject var viewModel: AgendaViewModel
    
    var body: some View {
        VStack {
            Text("Hello, Agenda!")
            
            Button("Create Appointment") {
                viewModel.navigateToCreateAppointment()
            }
            
            Button("Details of Appointment") {
                viewModel.navigateToAppointmentDetails(appointment: .init())
            }
            
            Toggle("User Authentication", isOn: $viewModel.userAuthenticated)
        }
    }
}

#Preview {
    let coordinator = makeAgendaFlowCoordinator()
    let databaseService = DatabaseService(context: makeMainContext())
    
    AgendaView(viewModel: .init(coordinator: coordinator, databaseService: databaseService))
}
