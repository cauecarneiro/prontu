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

    enum ScheduleType: String, CaseIterable, Identifiable {
        case appointment = "Agendamento"
        case block = "Bloqueio"

        var id: String { rawValue }
    }

    weak private var coordinator: (any CreateAppointmentCoordinatorProtocol)?
    private let databaseService: DatabaseService
    
    let dataset = DatasetService.shared

    @Published var scheduleType: ScheduleType = .appointment
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

    var shouldShowAppointmentFields: Bool {
        scheduleType == .appointment
    }

    var footerTitle: String {
        switch scheduleType {
        case .appointment:
            return "Agendar"
        case .block:
            return "Bloquear"
        }
    }

    var canSave: Bool {
        switch scheduleType {
        case .appointment:
            return selectedClient != nil
        case .block:
            return true
        }
    }

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
        guard canSave else {
            print("Cliente não selecionado")
            return
        }
        
        let startDateTime = AppointmentScheduleValidator.combine(
            date: selectedDate,
            time: selectedStartTime
        )
        
        let endDateTime = AppointmentScheduleValidator.endDate(
            startDate: startDateTime,
            duration: selectedDuration
        )
        
        guard verifyConflicts(from: startDateTime, to: endDateTime) else {
            alertMessage = "Não é possível agendar em horários que já possuem agendamentos."
            return
        }
        
        let appointment = Appointment(
            startDate: startDateTime,
            endDate: endDateTime,
            status: appointmentStatus,
            client: appointmentClient,
            exercises: appointmentExercises,
            equipment: appointmentEquipment,
            notes: observations
        )
        
        databaseService.add(element: appointment)
        
        dismissCreateAppointment()
    }
    
    private func reset() {
        Task {
            await Task.yield()
            
            await MainActor.run {
                scheduleType = .appointment
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
        !AppointmentScheduleValidator.hasConflict(
            databaseService: databaseService,
            from: startDate,
            to: endDate
        )
    }

    private var appointmentStatus: AppointmentStatus {
        switch scheduleType {
        case .appointment:
            return .scheduled
        case .block:
            return .blocked
        }
    }

    private var appointmentClient: Client? {
        switch scheduleType {
        case .appointment:
            return selectedClient
        case .block:
            return nil
        }
    }

    private var appointmentExercises: String? {
        switch scheduleType {
        case .appointment:
            return exercicio
        case .block:
            return nil
        }
    }

    private var appointmentEquipment: String? {
        switch scheduleType {
        case .appointment:
            return resultado
        case .block:
            return nil
        }
    }
}
