//
//  CreateAppointmentView.swift
//  Challenge13
//
//  Created by Caio Mandarino on 01/04/26.
//

import SwiftUI

struct CreateAppointmentView: View {
    
    @ObservedObject var viewModel: CreateAppointmentViewModel
    @FocusState private var focusedField: FocusField?
    
    init(viewModel: CreateAppointmentViewModel) {
        self.viewModel = viewModel
    }
    
    
    enum FocusField: Hashable {
        case name, contactInfo, observations
    }

    private enum Layout {
        static let toolbarButtonMaxWidth: CGFloat = 30
    }

    private enum ScrollAnchor: String {
        case contactSection
        case notesSection
    }
    
    var body: some View {
        
        VStack(spacing:0) {
            
            ScrollView {

                Picker("", selection: $viewModel.scheduleType) {
                    ForEach(CreateAppointmentViewModel.ScheduleType.allCases) { scheduleType in
                        Text(scheduleType.rawValue)
                            .tag(scheduleType)
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                if viewModel.shouldShowAppointmentFields {
                    PickerClientButton(client: viewModel.selectedClient) {
                        viewModel.presentSelectedClient()
                    }
                    .padding()
                }

                AppointmentPickerList(
                    selectedDate: $viewModel.selectedDate,
                    selectedStartTime: $viewModel.selectedStartTime,
                    selectedDuration: $viewModel.selectedDuration,
                    selectedFrequency: $viewModel.selectedFrequency
                )
                .padding()

                if viewModel.shouldShowAppointmentFields {
                    AddEquipament(
                        resultado: viewModel.resultado,
                        action: {
                            viewModel.presentGenerateEquipamentSheet()
                        }
                    )
                    .padding()
                }

                NotesTextArea(
                    text: $viewModel.observations,
                    placeholder: "Escreva mais detalhes...",
                    icon: "list.bullet",
                    focusedField: $focusedField,
                    field: .observations
                )
                .id(ScrollAnchor.notesSection.rawValue)
                .padding()
                
                FooterButton(
                    title: viewModel.footerTitle,
                    isEnabled: viewModel.canSave,
                    action: {
                        viewModel.saveAppointment()
                    }
                )
            }
        }
        .navigationBarTitle("Agendamento")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .enableSwipeBack()
        .scrollDismissesKeyboard(.interactively)
        .background(GlobalConfiguration.groupedBackground)
        .onTapGesture {
            // Fecha o teclado ao tocar fora
            focusedField = nil
        }
        .alert("Conflito de horários", isPresented: .init(value: $viewModel.alertMessage)) {

        } message: {
            Text(viewModel.alertMessage ?? "")
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Voltar", systemImage: "chevron.backward") {
                    viewModel.dismissCreateAppointment()
                }
                .frame(maxWidth: Layout.toolbarButtonMaxWidth)
                .tint(.black)
            }
        }
    }
}
