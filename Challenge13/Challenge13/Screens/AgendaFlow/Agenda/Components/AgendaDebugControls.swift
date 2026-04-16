//
//  AgendaDebugControls.swift
//  Challenge13
//
//  Created by Caio Mandarino on 16/04/26.
//

import SwiftUI

struct AgendaDebugControls: View {
    let onCreateAppointment: () -> Void
    let onOpenAppointmentDetails: () -> Void
    @Binding var userAuthenticated: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: GlobalConfiguration.normalSpacing) {
            Text("Hello, Agenda!")

            Button("Create Appointment", action: onCreateAppointment)

            Button("Details of Appointment", action: onOpenAppointmentDetails)

            Toggle("User Authentication", isOn: $userAuthenticated) // TODO: Remover
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    @Previewable @State var userAuthenticated = false

    AgendaDebugControls(
        onCreateAppointment: {},
        onOpenAppointmentDetails: {},
        userAuthenticated: $userAuthenticated
    )
    .padding()
}
