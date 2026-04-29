//
//  AppointmentDetailsContainerView.swift
//  Challenge13
//
//  Created by Codex on 26/04/26.
//

import SwiftUI

struct AppointmentDetailsContainerView<Field: Hashable>: View {

    @ObservedObject var viewModel: AppointmentDetailsViewModel
    @FocusState.Binding var focusedField: Field?
    let notesField: Field

    var body: some View {
        VStack(spacing: GlobalConfiguration.normalSpacing) {
            AppointmentDetailsStatusView(status: viewModel.currentStatus)
                .frame(maxWidth: .infinity, alignment: .trailing)

            if let client = viewModel.client {
                HStack {
                    ClientRow(client: client)
                }
                .padding(.horizontal)
                .background {
                    RoundedRectangle(cornerRadius: GlobalConfiguration.normalCornerRadius)
                        .foregroundStyle(GlobalConfiguration.cardBackground)
                }
            }

            appointmentScheduleCard

            if viewModel.appointment.status != .blocked {
                AddEquipament(
                    resultado: viewModel.result,
                    action: {}
                )
                .allowsHitTesting(false)
            }
            
            NotesTextArea(
                text: $viewModel.observation,
                placeholder: "Escreva mais detalhes...",
                icon: "list.bullet",
                focusedField: $focusedField,
                field: notesField
            )
            .disabled(true)

            Spacer()
        }
    }

    private var appointmentScheduleCard: some View {
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
                .foregroundStyle(GlobalConfiguration.cardBackground)
        }
    }
}

#Preview {
    @FocusState var focusedField: String?
    
    AppointmentDetailsContainerView(
        viewModel: .init(
            coordinator: nil,
            databaseService: .init(context: makeMainContext()),
            appointment: .init(startDate: .now, endDate: .now)
        ),
        focusedField: $focusedField,
        notesField: ""
    )
}
