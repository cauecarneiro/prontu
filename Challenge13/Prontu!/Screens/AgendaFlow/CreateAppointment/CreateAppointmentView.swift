//
//  CreateAppointmentView.swift
//  Challenge13
//
//  Created by Caio Mandarino on 01/04/26.
//

import SwiftUI

struct CreateAppointmentView: View {
    
    @ObservedObject var viewModel: CreateAppointmentViewModel
    
    struct StringValues {
        static var pickerObjetivo : String  { "Objetivo" }
        static var pickerExercicio: String  { "Exercício" }
        static var pickerRegiao   : String  { "Região" }
        static var buttonPrever   : String  { "Prever equipamento" }
        static var resultadoPrefix: String  { "Resultado: " }
    }
    
    var body: some View {
        VStack {
            Text("Hello, CreateAppointmentView!")
            
            Button("Create Client") {
                viewModel.presentCreateClient()
            }

                Picker(StringValues.pickerObjetivo, selection: $viewModel.objetivo) {
                    ForEach(viewModel.dataset.objetivos, id: \.self) { Text($0) }
                }

                Picker(StringValues.pickerExercicio, selection: $viewModel.exercicio) {
                    ForEach(viewModel.dataset.exercicios, id: \.self) { Text($0) }
                }

                Picker(StringValues.pickerRegiao, selection: $viewModel.regiao) {
                    ForEach(viewModel.dataset.regioes, id: \.self) { Text($0) }
                }

                Button(StringValues.buttonPrever) {
                    viewModel.calcularEquipamento()
                }

                Text("\(StringValues.resultadoPrefix)\(viewModel.resultado)")
                    .font(.headline)
            }
            .padding()
        }
    }


#Preview {
    let coordinator = makeAgendaFlowCoordinator()

    CreateAppointmentView(viewModel: .init(coordinator: coordinator))
}
