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
            viewModel.navigateToEditAppointment(appointment: .init(startDate: .now, endDate: .now))
        }
    }
}


#Preview {
    
    let coordinator = makeAgendaFlowCoordinator()
    
    AppointmentDetailsView(viewModel: .init(coordinator: coordinator))
}
