//
//  AppointmentChatEngine.swift
//  Challenge13
//
//  Created by Caio Mandarino on 18/04/26.
//

import Foundation

protocol AppointmentProviding: Sendable {
    func fetchAppointments(from start: Date, to end: Date) async throws -> [Appointment]
}

actor AppointmentChatEngine {
    private let provider: AppointmentProviding
    private let classifier: AppointmentIntentClassifier
    private let calendar: Calendar

    init(
        provider: AppointmentProviding,
        classifier: AppointmentIntentClassifier,
        calendar: Calendar = .autoupdatingCurrent
    ) {
        self.provider = provider
        self.classifier = classifier
        self.calendar = calendar
    }

    func reply(to userText: String) async throws -> MessageChat {
        let intent = try await classifier.classify(userText)

        switch intent {
        case .checkAvailableTimes:
            return try await makeAvailableTimesMessage()

        case .nextAppointment:
            return try await makeNextAppointmentMessage()

        case .todayAgenda:
            return try await makeTodayAgendaMessage()

        case .unsupported:
            return await MessageChat(
                author: .hero,
                text: "Ainda não consigo responder esse tipo de pergunta. Tente consultar horários disponíveis, próximo atendimento ou agenda de hoje."
            )
        }
    }
}

private extension AppointmentChatEngine {
    private func makeNextAppointmentMessage(now: Date = .now) async throws -> MessageChat {
        let end = calendar.date(byAdding: .day, value: 30, to: now) ?? now
        let appointments = try await provider.fetchAppointments(from: now, to: end)

        let next = appointments
            .filter { $0.endDate > now }
            .filter { $0.status == .scheduled || $0.status == .confirmed }
            .sorted { $0.startDate < $1.startDate }
            .first

        guard let next else {
            return await MessageChat(
                author: .hero,
                text: "Você não possui próximos atendimentos agendados."
            )
        }

        let date = next.startDate.formatted(date: .complete, time: .shortened)
        let client = next.client?.name ?? "cliente não identificado"

        return await MessageChat(
            author: .hero,
            text: "Seu próximo atendimento é com \(client), em \(date)."
        )
    }
}

private extension AppointmentChatEngine {
    private func makeTodayAgendaMessage(now: Date = .now) async throws -> MessageChat {
        let startOfDay = calendar.startOfDay(for: now)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? now

        let appointments = try await provider.fetchAppointments(from: startOfDay, to: endOfDay)
        let valid = appointments
            .filter { $0.status == .scheduled || $0.status == .confirmed }
            .sorted { $0.startDate < $1.startDate }

        guard !valid.isEmpty else {
            return await MessageChat(
                author: .hero,
                text: "Sua agenda de hoje está livre."
            )
        }

        guard let first = valid.first?.startDate.formatted(date: .omitted, time: .shortened) else {
            return await MessageChat(
                author: .hero,
                text: "Error ao processar sua agenda. Por favor, tente novamente mais tarde."
            )
        }
        
        guard let last = valid.last?.startDate.formatted(date: .omitted, time: .shortened) else {
            return await MessageChat(
                author: .hero,
                text: "Error ao processar sua agenda. Por favor, tente novamente mais tarde."
            )
        }

        let text: String
        if valid.count == 1 {
            let client = valid[0].client?.name ?? "cliente não identificado"
            text = "Hoje você tem 1 atendimento, às \(first), com \(client)."
        } else {
            text = "Hoje você tem \(valid.count) atendimentos. O primeiro começa às \(first) e o último às \(last)."
        }

        return await MessageChat(
            author: .hero,
            text: text
        )
    }
}

private extension AppointmentChatEngine {
    private func makeAvailableTimesMessage(
        now: Date = .now,
        minimumDurationMinutes: Int = 60
    ) async throws -> MessageChat {
        let workInterval = try makeWorkInterval(for: now)
        let appointments = try await provider.fetchAppointments(
            from: workInterval.start,
            to: workInterval.end
        )

        let busy = appointments
            .filter { $0.status == .scheduled || $0.status == .confirmed }
            .sorted { $0.startDate < $1.startDate }

        let slots = freeSlots(
            in: workInterval,
            busyAppointments: busy,
            minimumDurationMinutes: minimumDurationMinutes
        )

        guard !slots.isEmpty else {
            return await MessageChat(
                author: .hero,
                text: "Não encontrei horários livres hoje com pelo menos \(minimumDurationMinutes) minutos."
            )
        }

        let top3 = slots.prefix(3).map {
            "\($0.start.formatted(date: .omitted, time: .shortened)) às \($0.end.formatted(date: .omitted, time: .shortened))"
        }

        let text = "Encontrei estes horários livres hoje: \(top3.joined(separator: ", "))."

        return await MessageChat(
            author: .hero,
            text: text
        )
    }

    private func makeWorkInterval(for date: Date) throws -> DateInterval {
        let startOfDay = calendar.startOfDay(for: date)

        guard
            let start = calendar.date(bySettingHour: 8, minute: 0, second: 0, of: startOfDay),
            let end = calendar.date(bySettingHour: 18, minute: 0, second: 0, of: startOfDay)
        else {
            throw NSError(domain: "AppointmentChatEngine", code: 1)
        }

        return DateInterval(start: start, end: end)
    }

    private func freeSlots(
        in workInterval: DateInterval,
        busyAppointments: [Appointment],
        minimumDurationMinutes: Int
    ) -> [DateInterval] {
        var result: [DateInterval] = []
        var cursor = workInterval.start

        for appointment in busyAppointments {
            if cursor < appointment.startDate {
                let gap = cursor.distance(to: appointment.startDate) / 60
                if gap >= Double(minimumDurationMinutes) {
                    result.append(.init(start: cursor, end: appointment.startDate))
                }
            }
            cursor = max(cursor, appointment.endDate)
        }

        if cursor < workInterval.end {
            let gap = cursor.distance(to: workInterval.end) / 60
            if gap >= Double(minimumDurationMinutes) {
                result.append(.init(start: cursor, end: workInterval.end))
            }
        }

        return result
    }
}
