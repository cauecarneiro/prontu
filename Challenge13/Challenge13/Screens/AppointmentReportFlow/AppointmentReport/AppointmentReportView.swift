//
//  AppointmentReportView.swift
//  Challenge13
//
//  Created by Caio Mandarino on 01/04/26.
//

import SwiftUI

struct AppointmentReportView: View {
    
    @ObservedObject var viewModel: AppointmentReportViewModel
    
    var body: some View {
        VStack {
            Text("Hello, AppointmentReportView!")

            Button("Client History") {
                viewModel.navigateToClientDetails(client: .init(name: "Caio", contactInfo: "99999"))
            }
            
            Button("Open Chatbot") {
                viewModel.presentToChatbot()
            }
        }
    }
}

#Preview {
    let coordinator = AppointmentReportFlowCoordinator(factory: .init(databaseService: .init(context: makeMainContext())))
    
    AppointmentReportView(
        viewModel: .init(
            coordinator: coordinator, databaseService: .init(context: makeMainContext())
        )
    )
}
