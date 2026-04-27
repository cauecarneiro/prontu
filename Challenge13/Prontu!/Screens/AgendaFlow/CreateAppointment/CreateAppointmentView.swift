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
    
    private enum ScrollAnchor: String {
        case contactSection
        case notesSection
    }
    
    var body: some View {
        
        VStack(spacing:0) {
            
            ScrollView {
                
                PickerClientButton(client: viewModel.selectedClient) {
                    viewModel.presentSelectedClient()
                }
                .padding()
                
                AppointmentPickerList(
                    selectedDate: $viewModel.selectedDate,
                    selectedStartTime: $viewModel.selectedStartTime,
                    selectedDuration: $viewModel.selectedDuration,
                    selectedFrequency: $viewModel.selectedFrequency
                )
                .padding()
                
                AddEquipament(
                    resultado: viewModel.resultado,
                    action: {
                        viewModel.presentGenerateEquipamentSheet()
                    }
                )
                
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
                    title: "Agendar",
                    isEnabled: viewModel.selectedClient != nil,
                    action: {
                        viewModel.saveAppointment()
                    }
                )
            }
        }
        .navigationBarTitle("Agendamento")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .scrollDismissesKeyboard(.interactively)
        .background(Color(.systemGroupedBackground))
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
                .frame(maxWidth: 30)
                .tint(.black)
            }
        }
    }
}
