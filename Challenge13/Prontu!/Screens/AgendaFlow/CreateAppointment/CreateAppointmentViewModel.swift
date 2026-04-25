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

    @Published var selectedDate: Date = Date()
    @Published var selectedStartTime: Date = Date()
    @Published var selectedDuration: Int = 60
    @Published var selectedFrequency: AppointmentPickerList.Frequency = .nunca
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
    
    func saveAppointment() {
        
        guard let client = selectedClient else {
            print("Cliente não selecionado")
            return
        }
        
        let startDateTime = combine(date: selectedDate, time: selectedStartTime)
        
        let endDateTime = Calendar.current.date(
            byAdding: .minute,
            value: selectedDuration,
            to: startDateTime
        ) ?? startDateTime
        
        let appointment = Appointment(
            startDate: startDateTime,
            endDate: endDateTime,
            status: .scheduled,
            client: client,
            exercises: exercicio,
            equipment: resultado,
            notes: observations
        )
        
        databaseService.add(element: appointment)
    }
    
    func combine(date: Date, time: Date) -> Date {
        let calendar = Calendar.current
        
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
        
        var final = DateComponents()
        final.year = dateComponents.year
        final.month = dateComponents.month
        final.day = dateComponents.day
        final.hour = timeComponents.hour
        final.minute = timeComponents.minute
        
        return calendar.date(from: final) ?? date
    }
    
}
