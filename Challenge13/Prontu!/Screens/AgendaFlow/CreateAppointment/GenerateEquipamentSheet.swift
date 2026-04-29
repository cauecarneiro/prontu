//
//  GenerateEquipamentSheet.swift
//  Prontu!
//
//  Created by Linda Marie Ribeiro Alves Correa dos Santos on 25/04/26.
//

import SwiftUI

struct GenerateEquipamentSheet: View {
    
    @ObservedObject var viewModel: CreateAppointmentViewModel
    @Environment(\.dismiss) private var dismiss
    
    struct StringValues {
        static var pickerObjetivo : String  { "Objetivo" }
        static var pickerExercicio: String  { "Exercício" }
        static var pickerRegiao   : String  { "Região" }
        static var buttonPrever   : String  { "Prever equipamento" }
        static var resultadoPrefix: String  { "Resultado: " }
    }
    
    var body: some View {
        
        NavigationStack{
            VStack{
                VStack{
                    AppointmentDetailsCardRow(title: StringValues.pickerObjetivo){
                        Picker("", selection: $viewModel.objetivo) {
                            ForEach(viewModel.dataset.objetivos, id: \.self) { Text($0) }
                        }
                    }
                    Divider()
                    
                    AppointmentDetailsCardRow(title: StringValues.pickerExercicio){
                        Picker("", selection: $viewModel.exercicio) {
                            ForEach(viewModel.dataset.exercicios, id: \.self) { Text($0) }
                        }
                    }
                    Divider()
                    
                    AppointmentDetailsCardRow(title: StringValues.pickerRegiao){
                        Picker(StringValues.pickerRegiao, selection: $viewModel.regiao) {
                            ForEach(viewModel.dataset.regioes, id: \.self) { Text($0) }
                        }
                    }
                }
                .tint(.gray)
                .fontWeight(.semibold)
                .padding()
                .background{
                    RoundedRectangle(cornerRadius: GlobalConfiguration.normalCornerRadius)
                        .foregroundStyle(.white)
                }
                
                FooterButton(
                    title: "Gerar sugestão",
                    isEnabled: !viewModel.objetivo.isEmpty &&
                    !viewModel.exercicio.isEmpty &&
                    !viewModel.regiao.isEmpty,
                    action: {
                        viewModel.calcularEquipamento()
                    }
                )
                
                if !viewModel.resultado.isEmpty {
                    Text("\(StringValues.resultadoPrefix)\(viewModel.resultado)")
                        .font(.headline)
                        .transition(.opacity)
                    
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Recursos da sessão")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .fontWeight(.semibold)
                    }
                    .tint(.black)
                }
            }
            
        }
    }
}


