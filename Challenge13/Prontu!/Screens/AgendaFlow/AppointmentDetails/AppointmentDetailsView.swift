//
//  AppointmentDetailsView.swift
//  Challenge13
//
//  Created by Caio Mandarino on 01/04/26.
//

import SwiftUI

struct AppointmentDetailsView: View {

    @ObservedObject var viewModel: AppointmentDetailsViewModel
    @FocusState private var focusedField: FocusField?

    private enum Layout {
        static let toolbarButtonMaxWidth: CGFloat = 30
    }

    private enum FocusField {
        case active
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: GlobalConfiguration.normalSpacing) {
                if viewModel.isEditing {
                    AppointmentDetailsEditContainerView(
                        viewModel: viewModel,
                        focusedField: $focusedField,
                        notesField: .active
                    )
                } else {
                    AppointmentDetailsContainerView(
                        viewModel: viewModel,
                        focusedField: $focusedField,
                        notesField: .active
                    )

                    DeleteButton(action: viewModel.deleteAppointment)
                }
            }
            .padding()
        }
        .scrollIndicators(.hidden)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(GlobalConfiguration.groupedBackground)
        .navigationTitle("Sessão")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .enableSwipeBack()
        .alert("Conflito de horários", isPresented: .init(value: $viewModel.alertMessage)) {

        } message: {
            Text(viewModel.alertMessage ?? "")
        }
        .toolbar {
            if viewModel.appointment.status != .blocked {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(
                        viewModel.isEditing ? "Cancelar edição" : "Editar",
                        systemImage: viewModel.isEditing ? "pencil.slash" : "pencil"
                    ) {
                        focusedField = nil
                        viewModel.toggleEditing()
                    }
                    .frame(maxWidth: Layout.toolbarButtonMaxWidth)
                    .tint(.black)
                }
            }

            ToolbarItem(placement: .topBarLeading) {
                Button("Voltar", systemImage: "chevron.backward") {
                    viewModel.dismiss()
                }
                .frame(maxWidth: Layout.toolbarButtonMaxWidth)
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
