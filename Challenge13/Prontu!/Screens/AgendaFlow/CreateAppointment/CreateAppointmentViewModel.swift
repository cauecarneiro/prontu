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
    @Published var alertMessage: String?
    
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
        reset()
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
        
        guard verifyConflicts(from: startDateTime, to: endDateTime) else {
            alertMessage = "Não é possível agendar em horários que já possuem agendamentos."
            return
        }
        
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
        
        dismissCreateAppointment()
    }
    
    private func combine(date: Date, time: Date) -> Date {
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
    
    private func reset() {
        Task {
            await Task.yield()
            
            await MainActor.run {
                selectedDate = Date()
                selectedStartTime = Date()
                selectedDuration = 0
                selectedDuration = 60
                selectedFrequency = .nunca
                resultado = ""
                observations = ""
                selectedClient = nil
            }
        }
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
    
    private func verifyConflicts(from startDate: Date, to endDate: Date) -> Bool {
        let conflicts = databaseService.fetchOverlappingAppointments(from: startDate, to: endDate)
        return conflicts.isEmpty
    }
}
