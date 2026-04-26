//
//  AppointmentDetailsStatusPicker.swift
//  Challenge13
//
//  Created by Caio Mandarino on 23/04/26.
//

import SwiftUI

struct AppointmentDetailsStatusPicker: View {
    
    @Binding var selectedStatus: AppointmentStatus
    
    var color: Color {
        switch selectedStatus {
        case .scheduled:
            return GlobalConfiguration.primaryBlue
        case .confirmed:
            return GlobalConfiguration.primaryBlue
        case .cancelled:
            return .red
        case .finished:
            return GlobalConfiguration.primaryGreen
        case .blocked:
            return .gray
        }
    }
    
    var body: some View {
        HStack() {
            circleMark
            
            Picker("AppointmentDetailsStatusPicker", selection: $selectedStatus) {
                Text("Agendado")
                    .tag(AppointmentStatus.scheduled)
                
                Text("Confirmado")
                    .tag(AppointmentStatus.confirmed)
                
                Text("Cancelado")
                    .tag(AppointmentStatus.cancelled)
                
                Text("Concluído")
                    .tag(AppointmentStatus.finished)
            }
            .tint(color)
        }
        .padding(.leading, 4)
        .padding(4)
        .background {
            ZStack {
                Capsule()
                    .fill(color.opacity(0.1))
                
                Capsule()
                    .stroke(lineWidth: 1)
                    .foregroundStyle(color)
            }
        }
    }
    
    private var circleMark: some View {
        ZStack {
            Circle()
                .frame(maxWidth: 10)
                .foregroundStyle(color)
                .padding(4)
                .background {
                    Circle()
                        .foregroundStyle(color.opacity(0.25))
                }
        }
    }
}

#Preview {
    AppointmentDetailsStatusPicker(selectedStatus: .constant(.scheduled))
}
