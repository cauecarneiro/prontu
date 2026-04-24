//
//  CreateAppointmentView.swift
//  Challenge13
//
//  Created by Caio Mandarino on 01/04/26.
//

import SwiftUI

struct CreateAppointmentView: View {
    
    @ObservedObject var viewModel: CreateAppointmentViewModel
    @State private var showClientSheet = false
    @FocusState private var focusedField: FocusField?
    
    init(viewModel: CreateAppointmentViewModel) {
        self.viewModel = viewModel
    }
    
    struct StringValues {
        static var pickerObjetivo : String  { "Objetivo" }
        static var pickerExercicio: String  { "Exercício" }
        static var pickerRegiao   : String  { "Região" }
        static var buttonPrever   : String  { "Prever equipamento" }
        static var resultadoPrefix: String  { "Resultado: " }
    }
    
    
    enum FocusField: Hashable {
        case name, contactInfo, observations
    }
    
    private enum ScrollAnchor: String {
        case contactSection
        case notesSection
    }
    
    var body: some View {
        VStack(spacing:0){
            
            PickerClientButton(client: viewModel.selectedClient) {
                viewModel.presentSelectedClient()
            }
            .padding()
            
            AppointmentPickerList()
                .padding()
            
            AddEquipament()
            
            NotesTextArea(
                text: $viewModel.observations,
                placeholder: "Anotações sobre o cliente...",
                icon: "list.bullet",
                focusedField: $focusedField,
                field: .observations
            )
            .id(ScrollAnchor.notesSection.rawValue)
            .padding(10)
            
            //                Picker(StringValues.pickerObjetivo, selection: $viewModel.objetivo) {
            //                    ForEach(viewModel.dataset.objetivos, id: \.self) { Text($0) }
            //                }
            //
            //                Picker(StringValues.pickerExercicio, selection: $viewModel.exercicio) {
            //                    ForEach(viewModel.dataset.exercicios, id: \.self) { Text($0) }
            //                }
            //
            //                Picker(StringValues.pickerRegiao, selection: $viewModel.regiao) {
            //                    ForEach(viewModel.dataset.regioes, id: \.self) { Text($0) }
            //                }
            //
            //                Button(StringValues.buttonPrever) {
            //                    viewModel.calcularEquipamento()
            //                }
            //
            //                Text("\(StringValues.resultadoPrefix)\(viewModel.resultado)")
            //                    .font(.headline)
            
            //            FooterButton(
            //                title: "Agendar",
            //                isEnabled: viewModel.selectedClient != nil,
            //                action: {
            //                    print("salvar")
            //                }
            //            )
        }
        .navigationBarTitle("Agendamento")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
        .onTapGesture {
            // Fecha o teclado ao tocar fora
            focusedField = nil
        }
    }
}


