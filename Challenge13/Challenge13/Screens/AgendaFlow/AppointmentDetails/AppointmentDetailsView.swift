//
//  AppointmentDetailsView.swift
//  Challenge13
//
//  Created by Caio Mandarino on 01/04/26.
//

import SwiftUI

struct AppointmentDetailsView: View {
    
    @ObservedObject var viewModel: AppointmentDetailsViewModel
    
    var body: some View {
        Text("Hello, AppointmentDetailsView!")
        
        Button("Edit Appointment") {
            viewModel.navigateToEditAppointment(appointment: .init())
        }
    }
}

#Preview {
    
    let coordinator = makeAgendaFlowCoordinator()
    let databaseService = DatabaseService(context: makeMainContext())
    
    AppointmentDetailsView(viewModel: .init(coordinator: coordinator))
}
