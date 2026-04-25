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
    private let databaseService: DatabaseService
    
    let dataset = DatasetService.shared

    @Published var objetivo: String = ""
    @Published var exercicio: String = ""
    @Published var regiao: String = ""
    @Published var resultado: String = ""
    @Published var observations: String = ""
    @Published var clients: [Client]
    @Published var selectedClient: Client?
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(coordinator: (any CreateAppointmentCoordinatorProtocol)?, databaseService: DatabaseService) {
        self.coordinator = coordinator
        objetivo  = DatasetService.shared.objetivos.first  ?? ""
        exercicio = DatasetService.shared.exercicios.first ?? ""
        regiao    = DatasetService.shared.regioes.first    ?? ""
        self.databaseService = databaseService
        self.clients = databaseService.getAllElements()
        
        observableDataBase()
    }
    
    func presentSelectedClient() {
        coordinator?.presentSelectedClient()
    }
    
    func presentGenerateEquipamentSheet() {
        coordinator?.presentGenerateEquipamentSheet()
    }
    
    func calcularEquipamento() {
        let input = EquipamentMLService.ExerciseInput(
            objetivo: objetivo,
            exercicio: exercicio,
            regiao: regiao
        )
        
        resultado = EquipamentMLService.shared.predict(input: input)
    }
    
    func dismissCreateAppointment() {
        coordinator?.dismissCreateAppointment()
    }
    
    
    private func observableDataBase(){
        databaseService.databaseChangePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                if let self {
                    self.clients = databaseService.getAllElements()
                }
            }
            .store(in: &cancellables)
        
    }
    
}
