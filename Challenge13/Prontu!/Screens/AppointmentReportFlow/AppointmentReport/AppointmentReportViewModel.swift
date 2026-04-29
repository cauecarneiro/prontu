//
//  AppointmentReportViewModel.swift
//  Challenge13
//
//  Created by Caio Mandarino on 01/04/26.
//

import Combine
import Foundation

enum ReportPeriod: String, CaseIterable {
    case week = "Semana"
    case month = "Mês"
    case year = "Ano"
}

struct ReportBarData: Identifiable {
    let id: String
    let label: String
    let count: Int
    let interval: DateInterval
    let isCurrentBucket: Bool

    init(id: String, label: String, count: Int, interval: DateInterval, isCurrentBucket: Bool) {
        self.id = id
        self.label = label
        self.count = count
        self.interval = interval
        self.isCurrentBucket = isCurrentBucket
    }
}

final class AppointmentReportViewModel: ObservableObject {
    weak private var coordinator: (any AppointmentReportCoordinatorProtocol)?
    private var databaseService: DatabaseService

    @Published var selectedPeriod: ReportPeriod = .week {
        didSet { selectedBarID = "" }
    }
    @Published var selectedBarID: String = ""
    @Published private var appointments: [Appointment]

    private var cancelables: Set<AnyCancellable> = []

    init(coordinator: (any AppointmentReportCoordinatorProtocol)?, databaseService: DatabaseService) {
        self.coordinator = coordinator
        self.databaseService = databaseService
        self.appointments = databaseService.getAllElements()
        observableDatabase()
    }


    func navigateToClientDetails(client: Client) {
        coordinator?.navigateToClientHistory(client: client, appointments: [])
    }

    func presentToChatbot() {
        coordinator?.presentSearchChatbot(appointments: appointments)
    }

    func navigateToPreferences() {
        coordinator?.navigateToPreferences()
    }

    func selectBar(id: String) {
        selectedBarID = id
    }

    var filteredAppointments: [Appointment] {
        guard let interval = selectedInterval else { return [] }
        return appointments.filter {
            $0.status != .cancelled &&
            $0.startDate >= interval.start &&
            $0.startDate < interval.end
        }
    }

    var totalSessions: Int { filteredAppointments.count }

    var totalHours: String { formatHours(totalHoursValue) }

    var averagePerDay: String {
        formatHours(totalHoursValue / Double(daysInSelectedBucket))
    }

    var uniqueClientsCount: Int {
        Set(filteredAppointments.compactMap { $0.client?.id }).count
    }

    var dateRangeLabel: String {
        guard let selectedBar else { return "" }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")

        switch selectedPeriod {
        case .week:
            formatter.dateFormat = "d MMM yyyy"
            return normalizedCapitalizedDate(from: selectedBar.interval.start, formatter: formatter)
        case .month:
            formatter.dateFormat = "MMMM yyyy"
            return normalizedCapitalizedDate(from: selectedBar.interval.start, formatter: formatter)
        case .year:
            formatter.dateFormat = "yyyy"
            return formatter.string(from: selectedBar.interval.start)
        }
    }

    var heroSubtitle: String {
        switch selectedPeriod {
        case .week: "Sessões do dia selecionado"
        case .month: "Sessões do mês selecionado"
        case .year: "Sessões do ano selecionado"
        }
    }

    var chartData: [ReportBarData] {
        let calendar = Calendar.current
        let now = Date()

        switch selectedPeriod {
        case .week:
            return weekChartData(calendar: calendar, now: now)
        case .month:
            return monthChartData(calendar: calendar, now: now)
        case .year:
            return yearChartData(calendar: calendar, now: now)
        }
    }

    private var yearChartWindow: Int { 5 }

    private var selectedBar: ReportBarData? {
        let data = chartData

        if let selected = data.first(where: { $0.id == selectedBarID }) {
            return selected
        }

        return data.first(where: \.isCurrentBucket) ?? data.first
    }

    private var selectedInterval: DateInterval? {
        selectedBar?.interval
    }

    private func weekChartData(calendar: Calendar, now: Date) -> [ReportBarData] {
        guard let interval = weekInterval(for: now, calendar: calendar) else { return [] }

        let labels = ["Seg", "Ter", "Qua", "Qui", "Sex", "Sáb", "Dom"]
        return (0..<7).compactMap { offset -> ReportBarData? in
            guard let day = calendar.date(byAdding: .day, value: offset, to: interval.start),
                  let nextDay = calendar.date(byAdding: .day, value: 1, to: day) else { return nil }

            let dayInterval = DateInterval(start: day, end: nextDay)
            let count = countValidAppointments(in: dayInterval)

            return ReportBarData(
                id: bucketID(for: dayInterval.start),
                label: labels[offset],
                count: count,
                interval: dayInterval,
                isCurrentBucket: calendar.isDate(day, equalTo: now, toGranularity: .day)
            )
        }
    }

    private func monthChartData(calendar: Calendar, now: Date) -> [ReportBarData] {
        guard let yearInterval = calendar.dateInterval(of: .year, for: now) else { return [] }

        return (0..<12).compactMap { offset -> ReportBarData? in
            guard let monthStart = calendar.date(byAdding: .month, value: offset, to: yearInterval.start),
                  let monthEnd = calendar.date(byAdding: .month, value: 1, to: monthStart) else { return nil }

            let monthInterval = DateInterval(start: monthStart, end: monthEnd)
            let count = countValidAppointments(in: monthInterval)

            return ReportBarData(
                id: bucketID(for: monthInterval.start),
                label: monthLabel(from: monthStart),
                count: count,
                interval: monthInterval,
                isCurrentBucket: calendar.isDate(monthStart, equalTo: now, toGranularity: .month)
            )
        }
    }

    private func yearChartData(calendar: Calendar, now: Date) -> [ReportBarData] {
        let currentYear = calendar.component(.year, from: now)
        let startYear = currentYear - (yearChartWindow - 1)

        return (startYear...currentYear).compactMap { year -> ReportBarData? in
            guard let yearStart = calendar.date(from: DateComponents(year: year, month: 1, day: 1)),
                  let yearEnd = calendar.date(byAdding: .year, value: 1, to: yearStart) else { return nil }

            let yearInterval = DateInterval(start: yearStart, end: yearEnd)
            let count = countValidAppointments(in: yearInterval)

            return ReportBarData(
                id: bucketID(for: yearInterval.start),
                label: "\(year)",
                count: count,
                interval: yearInterval,
                isCurrentBucket: year == currentYear
            )
        }
    }

    var sessionsCaption: String {
        guard let selectedBar, let previousBar else { return "" }

        let diff = selectedBar.count - previousBar.count
        guard diff != 0 else { return "= período ant." }
        return "\(diff > 0 ? "+" : "")\(diff) vs período ant."
    }

    var hoursCaption: String {
        guard let selectedBar, let previousBar else { return "" }

        let selectedHours = totalHours(in: selectedBar.interval)
        let previousHours = totalHours(in: previousBar.interval)
        let diff = selectedHours - previousHours

        guard abs(diff) >= 0.1 else { return "= período ant." }
        let sign = diff > 0 ? "+" : "-"
        return "\(sign)\(formatHours(abs(diff)))"
    }

    private var totalHoursValue: Double {
        filteredAppointments.reduce(0.0) { $0 + $1.endDate.timeIntervalSince($1.startDate) / 3600 }
    }

    private var previousBar: ReportBarData? {
        let data = chartData
        guard
            let selectedBar,
            let selectedIndex = data.firstIndex(where: { $0.id == selectedBar.id }),
            selectedIndex > 0
        else {
            return nil
        }

        return data[selectedIndex - 1]
    }

    private var daysInSelectedBucket: Int {
        let calendar = Calendar.current
        guard let selectedInterval else { return 1 }

        let days = calendar.dateComponents([.day], from: selectedInterval.start, to: selectedInterval.end).day ?? 1
        return max(days, 1)
    }

    private func weekInterval(for date: Date, calendar: Calendar) -> DateInterval? {
        let weekday = calendar.component(.weekday, from: date)
        let daysToMonday = (weekday - 2 + 7) % 7
        guard let monday = calendar.date(byAdding: .day, value: -daysToMonday, to: calendar.startOfDay(for: date)),
              let nextMonday = calendar.date(byAdding: .day, value: 7, to: monday) else { return nil }
        return DateInterval(start: monday, end: nextMonday)
    }

    private func monthLabel(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "MMM"
        var month = formatter.string(from: date).capitalized

        if month.hasSuffix(".") {
            month.removeLast()
        }

        return month
    }

    private func bucketID(for date: Date) -> String {
        "\(Int(date.timeIntervalSince1970))"
    }

    private func normalizedCapitalizedDate(from date: Date, formatter: DateFormatter) -> String {
        var value = formatter.string(from: date).capitalized

        if value.hasSuffix(".") {
            value.removeLast()
        }

        return value
    }

    private func countValidAppointments(in interval: DateInterval) -> Int {
        appointments.filter {
            $0.status != .cancelled &&
            $0.startDate >= interval.start &&
            $0.startDate < interval.end
        }.count
    }

    private func totalHours(in interval: DateInterval) -> Double {
        appointments
            .filter {
                $0.status != .cancelled &&
                $0.startDate >= interval.start &&
                $0.startDate < interval.end
            }
            .reduce(0.0) { $0 + $1.endDate.timeIntervalSince($1.startDate) / 3600 }
    }

    private func formatHours(_ hours: Double) -> String {
        let rounded = (hours * 10).rounded() / 10
        if rounded.truncatingRemainder(dividingBy: 1) == 0 {
            return "\(Int(rounded))h"
        }
        return String(format: "%.1fh", rounded)
    }

    private func observableDatabase() {
        databaseService.databaseChangePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                self.appointments = databaseService.getAllElements()
            }
            .store(in: &cancelables)
    }
}
