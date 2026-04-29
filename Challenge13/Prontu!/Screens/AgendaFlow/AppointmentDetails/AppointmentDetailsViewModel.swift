//
//  AppointmentDetailsViewModel.swift
//  Challenge13
//
//  Created by Caio Mandarino on 01/04/26.
//

import Combine
import Foundation

@MainActor
final class AppointmentDetailsViewModel: ObservableObject {
    private static let defaultEquipmentText = "Nenhum Equipamento"

    @Published var isEditing: Bool = false
    @Published var currentStatus: AppointmentStatus
    @Published var observation: String
    @Published var result: String
    @Published var clients: [Client]
    @Published var selectedClient: Client?
    @Published var selectedDate: Date
    @Published var selectedStartTime: Date
    @Published var selectedDuration: Int
    @Published var selectedFrequency: AppointmentPickerList.Frequency = .nunca
    @Published var alertMessage: String?

    weak private var coordinator: (any AppointmentDetailsCoordinateProtocol)?
    private let databaseService: DatabaseService
    let appointment: Appointment
    private var cancellables: Set<AnyCancellable> = []

    var client: Client? {
        selectedClient
    }

    var dateText: String {
        appointment.startDate.detailsDayText
    }

    var timeText: String {
        "\(appointment.startDate.detailsHourText) - \(appointment.endDate.detailsHourText)"
    }

    var durationText: String {
        appointment.startDate.distance(to: appointment.endDate).formattedDuration
    }

    var hasChanges: Bool {
        currentStatus != appointment.status ||
        observation != (appointment.notes ?? "") ||
        Self.equipmentValueToSave(result) != appointment.equipment ||
        selectedClient?.id != appointment.client?.id ||
        editedStartDate != appointment.startDate ||
        editedEndDate != appointment.endDate
    }

    init(
        coordinator: (any AppointmentDetailsCoordinateProtocol)?,
        databaseService: DatabaseService,
        appointment: Appointment
    ) {
        self.coordinator = coordinator
        self.databaseService = databaseService
        self.appointment = appointment
        self.currentStatus = appointment.status
        self.observation = appointment.notes ?? ""
        self.result = Self.equipmentText(for: appointment.equipment)
        self.clients = databaseService.getAllElements()
        self.selectedClient = appointment.client
        self.selectedDate = appointment.startDate
        self.selectedStartTime = appointment.startDate
        self.selectedDuration = AppointmentScheduleValidator.durationInMinutes(
            from: appointment.startDate,
            to: appointment.endDate
        )

        observableDataBase()
    }

    func toggleEditing() {
        if isEditing {
            resetEditingState()
            isEditing = false
            return
        }

        isEditing = true
    }

    func onClientClick() {
        coordinator?.presentSelectedClientDetails()
    }

    func saveChanges() {
        let startDateTime = editedStartDate
        let endDateTime = editedEndDate

        guard verifyConflicts(from: startDateTime, to: endDateTime) else {
            alertMessage = "Não é possível editar para horários que já possuem agendamentos."
            return
        }

        appointment.startDate = startDateTime
        appointment.endDate = endDateTime
        appointment.status = currentStatus
        appointment.notes = observation
        appointment.equipment = Self.equipmentValueToSave(result)
        appointment.client = selectedClient
        databaseService.save()

        isEditing = false
    }

    func deleteAppointment() {
        databaseService.delete(element: appointment)
        coordinator?.dismissAppointmentDetails()
    }

    func dismiss() {
        resetEditingState()
        coordinator?.dismissAppointmentDetails()
    }

    private func resetEditingState() {
        currentStatus = appointment.status
        observation = appointment.notes ?? ""
        result = Self.equipmentText(for: appointment.equipment)
        selectedClient = appointment.client
        selectedDate = appointment.startDate
        selectedStartTime = appointment.startDate
        selectedDuration = AppointmentScheduleValidator.durationInMinutes(
            from: appointment.startDate,
            to: appointment.endDate
        )
        selectedFrequency = .nunca
        isEditing = false
    }

    private func observableDataBase() {
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
            to: endDate,
            ignoring: appointment.id
        )
    }

    private var editedStartDate: Date {
        AppointmentScheduleValidator.combine(
            date: selectedDate,
            time: selectedStartTime
        )
    }

    private var editedEndDate: Date {
        AppointmentScheduleValidator.endDate(
            startDate: editedStartDate,
            duration: selectedDuration
        )
    }

    private static func equipmentText(for equipment: String?) -> String {
        guard let equipment, !equipment.isEmpty else {
            return defaultEquipmentText
        }

        return equipment
    }

    private static func equipmentValueToSave(_ equipment: String) -> String? {
        let trimmedEquipment = equipment.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedEquipment.isEmpty, trimmedEquipment != defaultEquipmentText else {
            return nil
        }

        return trimmedEquipment
    }
}

extension AppointmentDetailsViewModel: ClientSelectionViewModel {}
