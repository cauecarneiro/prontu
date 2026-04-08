//
//  CreateAppointmentView.swift
//  Challenge13
//
//  Created by Caio Mandarino on 01/04/26.
//

import SwiftUI

struct CreateAppointmentView: View {
    
    @ObservedObject var viewModel: CreateAppointmentViewModel
    
    var body: some View {
        VStack {
            Text("Hello, CreateAppointmentView!")
            
            Button("Create Client") {
                viewModel.presentCreateClient()
            }
        }
    }
}

#Preview {
    let coordinator = makeAgendaFlowCoordinator()

    CreateAppointmentView(viewModel: .init(coordinator: coordinator))
}
