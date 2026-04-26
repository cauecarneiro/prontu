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
        VStack(spacing: GlobalConfiguration.normalSpacing) {
            
            AppointmentDetailsStatusPicker(selectedStatus: $viewModel.currentStatus)
                .frame(maxWidth: .infinity, alignment: .trailing)
            
            if let client = viewModel.client {
                Button(action: viewModel.onClientClick) {
                    HStack {
                        ClientRow(client: client)
                        
                        Image(systemName: "chevron.forward")
                    }
                    .padding(.horizontal)
                    .background {
                        RoundedRectangle(cornerRadius: GlobalConfiguration.normalCornerRadius)
                            .foregroundStyle(.white)
                    }
                    
                }
                .buttonStyle(.plain)
            }
            
            VStack(alignment: .leading) {
                AppointmentDetailsCardRow(title: "Data") {
                    HStack {
                        Image(systemName: "calendar")
                        
                        Text(viewModel.dateText)
                    }
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                }
                
                Divider()
                
                AppointmentDetailsCardRow(title: "Horário") {
                    HStack {
                        Image(systemName: "calendar")
                        
                        Text(viewModel.timeText)
                    }
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                }
                
                Divider()
                
                AppointmentDetailsCardRow(title: "Duração") {
                    HStack {
                        Image(systemName: "clock.arrow.trianglehead.clockwise.rotate.90.path.dotted")
                        
                        Text(viewModel.durationText)
                    }
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: GlobalConfiguration.normalCornerRadius)
                    .foregroundStyle(.white)
            }
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Sessão")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit", systemImage: "pencil") {
                    viewModel.navigateToEditAppointment()
                }
                .frame(maxWidth: 30)
                .tint(.black)
            }
            
            ToolbarItem(placement: .topBarLeading) {
                Button("Voltar", systemImage: "chevron.backward") {
                    viewModel.dismiss()
                }
                .frame(maxWidth: 30)
                .tint(.black)
            }
        }
    }
}

#Preview {
    NavigationStack {
        let coordinator = makeAgendaFlowCoordinator()
        let appointment = Appointment(
            startDate: .now,
            endDate: .now.addingTimeInterval(3600 * 1.5),
            client: .init(name: "Caio", contactInfo: "999999")
        )
        
        AppointmentDetailsView(
            viewModel: .init(
                coordinator: coordinator,
                databaseService: .init(context: makeMainContext()),
                appointment: appointment
            )
        )
    }
}
