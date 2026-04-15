//
//  CalendarWeeklyStrip.swift
//  Challenge13
//
//  Created by Caio Mandarino on 15/04/26.
//

import SwiftUI
import SwiftData

struct CalendarWeeklyStrip: View {
    @Binding var selectedDate: Date
    let appointments: [Appointment]

    @State private var pages: [WeekPageData] = []
    @State private var visiblePageID: Date?

    @Namespace private var selectionNamespace

    private let calendar = Calendar.current
    private let locale = Locale(identifier: "pt-BR")
    private let centeredIndex = 2

    var body: some View {
        VStack(spacing: GlobalConfiguration.calendarHeaderSpacing) {
            header
            weekdayLabelsRow
            weekPager
        }
        .padding(.top, GlobalConfiguration.calendarPaddingTop)
        .padding(.bottom, GlobalConfiguration.calendarPaddingBottom)
    }

    // MARK: - Header

    private var headerTitle: String {
        let day = selectedDate.formatted(.dateTime.day().locale(locale))
        let monthRaw = selectedDate.formatted(.dateTime.month(.wide).locale(locale))
        let month = String(monthRaw.prefix(1)).uppercased() + String(monthRaw.dropFirst())
        let dateStr = "\(day) de \(month)"
        return calendar.isDateInToday(selectedDate) ? "Hoje, \(dateStr)" : dateStr
    }

    private var header: some View {
        HStack(alignment: .center, spacing: GlobalConfiguration.calendarHeaderSpacing) {
            Text(headerTitle)
                .font(.largeTitle.weight(.bold))
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(GlobalConfiguration.calendarTitleScaleFactor)

            Spacer(minLength: 0)

            HStack(spacing: GlobalConfiguration.calendarDayCellInnerSpacing) {
                navButton(systemName: "chevron.left", label: "Semana anterior") {
                    shiftWeek(by: -1)
                }
                navButton(systemName: "chevron.right", label: "Próxima semana") {
                    shiftWeek(by: 1)
                }
            }
        }
        .padding(.horizontal, GlobalConfiguration.normalSpacing)
    }

    private func navButton(
        systemName: String,
        label: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: GlobalConfiguration.calendarChevronSize, weight: .semibold))
                .frame(
                    width: GlobalConfiguration.calendarTapTargetSize,
                    height: GlobalConfiguration.calendarTapTargetSize
                )
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .foregroundStyle(GlobalConfiguration.primaryBlue)
        .accessibilityLabel(label)
    }

    // MARK: - Weekday Labels

    private var weekdayLabelsRow: some View {
        let anchor = startOfWeek(containing: selectedDate)
        let dates = weekDates(from: anchor)
        return HStack(spacing: 0) {
            ForEach(Array(dates.enumerated()), id: \.offset) { _, date in
                Text(date.formatted(.dateTime.weekday(.narrow).locale(locale)).uppercased())
                    .font(.system(size: GlobalConfiguration.calendarWeekdayFontSize, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, GlobalConfiguration.normalSpacing)
    }

    // MARK: - Week Pager

    private var weekPager: some View {
        ScrollViewReader { _ in
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(pages) { page in
                        weekRow(for: page)
                            .containerRelativeFrame(.horizontal)
                            .id(page.id)
                    }
                }
                .scrollTargetLayout()
            }
            .frame(height: GlobalConfiguration.calendarWeekPagerHeight)
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: $visiblePageID)
            .onScrollPhaseChange { _, newPhase in
                guard newPhase == .idle else { return }
                paginateIfNeeded()
            }
            .onAppear {
                setupInitialPages()
            }
        }
    }

    private func weekRow(for page: WeekPageData) -> some View {
        HStack(spacing: 0) {
            ForEach(page.dates, id: \.self) { date in
                CalendarWeeklyStripDayCell(
                    date: date,
                    isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                    hasAppointments: hasAppointments(on: date),
                    namespace: selectionNamespace
                )
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(
                        .spring(
                            response: GlobalConfiguration.calendarSpringResponse,
                            dampingFraction: GlobalConfiguration.calendarSpringDamping
                        )
                    ) {
                        selectedDate = date
                    }
                }
            }
        }
        .padding(.horizontal, GlobalConfiguration.normalSpacing)
    }

    // MARK: - Paging Logic

    private func setupInitialPages() {
        guard pages.isEmpty else { return }
        pages = makeBuffer(around: selectedDate)
        visiblePageID = pages[centeredIndex].id
    }

    private func paginateIfNeeded() {
        guard let visiblePageID,
              let visibleIndex = pages.firstIndex(where: { $0.id == visiblePageID })
        else { return }

        guard visibleIndex != centeredIndex else { return }

        let newWeekStart = pages[visibleIndex].id
        let currentWeekdayOffset = calendar.component(.weekday, from: selectedDate) - 1
        if let newDate = calendar.date(byAdding: .day, value: currentWeekdayOffset, to: newWeekStart) {
            selectedDate = newDate
        }

        pages = makeBuffer(around: pages[visibleIndex].id)
        self.visiblePageID = pages[centeredIndex].id
    }

    private func shiftWeek(by weekDelta: Int) {
        guard let newDate = calendar.date(byAdding: .weekOfYear, value: weekDelta, to: selectedDate) else { return }
        selectedDate = newDate
        pages = makeBuffer(around: newDate)
        visiblePageID = pages[centeredIndex].id
    }

    private func makeBuffer(around referenceDate: Date) -> [WeekPageData] {
        let anchor = startOfWeek(containing: referenceDate)
        return (-2...2).compactMap { offset in
            guard let weekStart = calendar.date(byAdding: .day, value: offset * 7, to: anchor) else { return nil }
            return WeekPageData(weekStart: weekStart, calendar: calendar)
        }
    }

    // MARK: - Helpers

    private func startOfWeek(containing date: Date) -> Date {
        let dayStart = calendar.startOfDay(for: date)
        let weekdayOffset = calendar.component(.weekday, from: dayStart) - 1
        return calendar.date(byAdding: .day, value: -weekdayOffset, to: dayStart) ?? dayStart
    }

    private func weekDates(from weekStart: Date) -> [Date] {
        (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: weekStart) }
    }

    private func hasAppointments(on date: Date) -> Bool {
        appointments.contains { apt in
            apt.status != .blocked && apt.status != .cancelled &&
            calendar.isDate(apt.startDate, inSameDayAs: date)
        }
    }
}

// MARK: - WeekPageData

private struct WeekPageData: Identifiable {
    let id: Date
    let dates: [Date]

    init(weekStart: Date, calendar: Calendar) {
        self.id = weekStart
        self.dates = (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: weekStart) }
    }
}

// MARK: - Preview

#Preview("CalendarWeeklyStrip") {
    @Previewable @State var selectedDate = Date()

    CalendarWeeklyStrip(
        selectedDate: $selectedDate,
        appointments: []
    )
    .padding()
    .background(Color(.systemBackground))
}
