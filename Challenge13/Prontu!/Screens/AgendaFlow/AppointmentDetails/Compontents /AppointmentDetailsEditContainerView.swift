//
//  AppointmentDetailsEditContainerView.swift
//  Challenge13
//
//  Created by Codex on 26/04/26.
//

import SwiftUI

struct AppointmentDetailsEditContainerView<Field: Hashable>: View {

    @ObservedObject var viewModel: AppointmentDetailsViewModel
    @FocusState.Binding var focusedField: Field?
    let notesField: Field

    var body: some View {
        VStack(spacing: GlobalConfiguration.normalSpacing) {
            AppointmentDetailsStatusPicker(selectedStatus: $viewModel.currentStatus)
                .frame(maxWidth: .infinity, alignment: .trailing)

            PickerClientButton(client: viewModel.selectedClient) {
                viewModel.onClientClick()
            }

            AppointmentPickerList(
                selectedDate: $viewModel.selectedDate,
                selectedStartTime: $viewModel.selectedStartTime,
                selectedDuration: $viewModel.selectedDuration,
                selectedFrequency: $viewModel.selectedFrequency
            )

            equipmentFieldCard

            NotesTextArea(
                text: $viewModel.observation,
                placeholder: "Escreva mais detalhes...",
                icon: "list.bullet",
                focusedField: $focusedField,
                field: notesField
            )

            FooterButton(
                title: "Salvar alterações",
                isEnabled: viewModel.hasChanges,
                action: {
                    focusedField = nil
                    viewModel.saveChanges()
                }
            )

        }
    }

    private var equipmentFieldCard: some View {
        VStack(alignment: .leading, spacing: GlobalConfiguration.normalSpacing) {
            Text("Recursos da Sessão")
                .font(.headline)
                .fontWeight(.semibold)

            TextField("Recursos", text: $viewModel.result)
                .textFieldStyle(.roundedBorder)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: GlobalConfiguration.normalCornerRadius)
                .foregroundStyle(GlobalConfiguration.cardBackground)
        }
    }

}
