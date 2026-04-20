//
//  CalendarWeeklyStrip.swift
//  Challenge13
//
//  Created by Caio Mandarino on 15/04/26.
//

import SwiftUI

struct CalendarWeeklyStrip: View {
    @Binding var selectedDate: Date
    @Binding var refresh: UUID
    let appointments: [Appointment]

    @State private var pages: [WeekPageData] = []
    @State private var visiblePageID: Date?

    @Namespace private var selectionNamespace

    private let calendar = Calendar.current
    private var isToday: Bool { calendar.isDateInToday(selectedDate) }
    private let centeredIndex = 2

    var body: some View {
        VStack(spacing: Layout.sectionSpacing) {
            CalendarWeeklyStripHeader(
                title: selectedDate.formatterRow(),
                onPrevious: { shiftWeek(by: -1) },
                onNext: { shiftWeek(by: 1) }
            )

            CalendarWeeklyStripWeekdayRow(weekDates: weekDates(from: startOfWeek(containing: selectedDate)))

            weekPager
        }
        .padding(.top, Layout.paddingTop)
        .padding(.bottom, Layout.paddingBottom)
    }

    // MARK: - Week Pager

    private var weekPager: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: .zero) {
                ForEach(pages) { page in
                    weekRow(for: page)
                        .containerRelativeFrame(.horizontal)
                        .id(page.id)
                }
            }
            .scrollTargetLayout()
        }
        .frame(height: Layout.weekPagerHeight)
        .scrollClipDisabled()
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

    private func weekRow(for page: WeekPageData) -> some View {
        HStack(spacing: .zero) {
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
                    withAnimation(Layout.selectionAnimation) {
                        if selectedDate == date && isToday {
                            refresh = UUID()
                            return
                        }
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
            withAnimation(Layout.selectionAnimation) {
                selectedDate = newDate
            }
        }

        pages = makeBuffer(around: pages[visibleIndex].id)
        self.visiblePageID = pages[centeredIndex].id
    }

    private func shiftWeek(by weekDelta: Int) {
        guard let newDate = calendar.date(byAdding: .weekOfYear, value: weekDelta, to: selectedDate) else { return }
        withAnimation(Layout.selectionAnimation) {
            selectedDate = newDate
        }
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

    // MARK: - Layout

    private enum Layout {
        static let sectionSpacing: CGFloat = 12
        static let paddingTop: CGFloat = 12
        static let paddingBottom: CGFloat = 8
        static let weekPagerHeight: CGFloat = 52
        static let selectionAnimation: Animation = .spring(response: 0.37, dampingFraction: 0.85)
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
        selectedDate: $selectedDate, refresh: .constant(.init()),
        appointments: []
    )
    .padding()
    .background(Color(.systemBackground))
}
