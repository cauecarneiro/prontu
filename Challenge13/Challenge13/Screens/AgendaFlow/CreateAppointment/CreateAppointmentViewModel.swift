//
//  CreateAppointmentViewModel.swift
//  Challenge13
//
//  Created by Caio Mandarino on 01/04/26.
//

import Combine
import Foundation

@MainActor
final class CreateAppointmentViewModel: ObservableObject {
    
    weak private var coordinator: (any CreateAppointmentCoordinatorProtocol)?
    
    let dataset = DatasetService.shared

    @Published var objetivo: String
    @Published var exercicio: String
    @Published var regiao: String
    @Published var resultado: String = ""
    
    init(coordinator: (any CreateAppointmentCoordinatorProtocol)?) {
        self.coordinator = coordinator
        objetivo  = DatasetService.shared.objetivos.first  ?? ""
        exercicio = DatasetService.shared.exercicios.first ?? ""
        regiao    = DatasetService.shared.regioes.first    ?? ""
    }
    
    func presentCreateClient() {
        coordinator?.presentCreateClient()
    }
    
    func calcularEquipamento() {
        let input = EquipamentMLService.ExerciseInput(
            objetivo: objetivo,
            exercicio: exercicio,
            regiao: regiao
        )
        
        resultado = EquipamentMLService.shared.predict(input: input)
    }
}
