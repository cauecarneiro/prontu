//
//  DailyScheduleCanvas.swift
//  Challenge13
//
//  Created by Caio Mandarino on 15/04/26.
//

import SwiftUI

struct DailyScheduleCanvas: View {
    let appointments: [Appointment]
    let date: Date
    let navigateTo: (Appointment) -> Void

    @State private var currentTime: Date = .now

    private let calendar = Calendar.autoupdatingCurrent
    private let timelineFocusID = "timeline-focus"

    private var visibleAppointments: [Appointment] {
        appointments
            .filter { $0.status != .cancelled }
            .sorted { $0.startDate < $1.startDate }
    }

    private var timelineNow: Date {
        guard !calendar.isDateInToday(date) else { return currentTime }

        let time = calendar.dateComponents([.hour, .minute], from: currentTime)
        var day = calendar.dateComponents([.year, .month, .day], from: date)
        day.hour = time.hour
        day.minute = time.minute
        return calendar.date(from: day) ?? date
    }

    private var isToday: Bool {
        calendar.isDateInToday(date)
    }

    var body: some View {
        GeometryReader { geometry in
            let metrics = Metrics(
                appointments: visibleAppointments,
                currentTime: timelineNow,
                canvasWidth: geometry.size.width,
                calendar: calendar
            )

            ScrollViewReader { proxy in
                ScrollView(.vertical) {
                    ZStack(alignment: .topLeading) {

                        ForEach(metrics.anchorTimes, id: \.self) { time in
                            positioned(y: metrics.yOffset(for: time), in: metrics) {
                                AnchorTimeMark(time: time)
                                    .padding(.leading)
                            }
                        }

                        ForEach(visibleAppointments, id: \.id) { appointment in
                            positioned(y: metrics.yOffset(for: appointment.startDate), in: metrics) {
                                ScheduleCard(
                                    appointment: appointment,
                                    state: cardState(for: appointment),
                                    navigateTo: navigateTo
                                )
                                .padding(.vertical, 4)
                                .padding(.leading, Layout.leftInset)
                                .frame(
                                    height: metrics.cardHeight(for: appointment),
                                    alignment: .topLeading
                                )
                            }
                        }

                        if isToday {
                            positioned(y: metrics.yOffset(for: timelineNow), in: metrics) {
                                CurrentTimeNeedle(
                                    time: timelineNow,
                                    leftInset: Layout.leftInset
                                )
                                .id(timelineFocusID)
                            }
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .onAppear {
                    focusCanvas(proxy: proxy)
                }
                .onChange(of: date) { _, _ in
                    currentTime = .now
                    focusCanvas(proxy: proxy)
                }
            }
        }
    }

    @ViewBuilder
    private func positioned<Content: View>(
        y: CGFloat,
        in metrics: Metrics,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(spacing: .zero) {
            Color.clear
                .frame(height: max(y, 0))

            content()
        }
        .frame(
            width: metrics.canvasWidth,
            height: metrics.canvasHeight,
            alignment: .topLeading
        )
    }

    private func cardState(for appointment: Appointment) -> ScheduleCardState {
        let now = currentTime
        let startOfToday = calendar.startOfDay(for: now)
        let appointmentDay = calendar.startOfDay(for: appointment.startDate)

        if appointmentDay < startOfToday {
            return .past
        }

        if appointmentDay > startOfToday {
            return .standard
        }

        if now > appointment.endDate {
            return .past
        }

        if now >= appointment.startDate {
            return .active
        }

        return .standard
    }

    private func focusCanvas(proxy: ScrollViewProxy) {
        guard isToday else { return }

        withAnimation(.smooth) {
            proxy.scrollTo(timelineFocusID, anchor: .center)
        }
    }

    private enum Layout {
        static let pixelsPerMinute: CGFloat = 4
        static let leftInset: CGFloat = 52
        static let minCardHeight: CGFloat = 24
        static let minCardWidth: CGFloat = 120
    }
}

private extension DailyScheduleCanvas {
    struct Metrics {
        let window: WorkingWindow
        let canvasWidth: CGFloat
        let canvasHeight: CGFloat
        let cardWidth: CGFloat
        let anchorTimes: [Date]

        init(
            appointments: [Appointment],
            currentTime: Date,
            canvasWidth: CGFloat,
            calendar: Calendar
        ) {
            let window = WorkingWindow.calculate(
                appointments: appointments,
                currentTime: currentTime
            )

            self.window = window
            self.canvasWidth = canvasWidth

            let minutes = window.end.timeIntervalSince(window.start) / 60
            self.canvasHeight = CGFloat(minutes) * Layout.pixelsPerMinute

            self.cardWidth = max(
                canvasWidth - Layout.leftInset - GlobalConfiguration.normalSpacing,
                Layout.minCardWidth
            )

            self.anchorTimes = Self.makeAnchorTimes(for: window, calendar: calendar)
        }

        func yOffset(for date: Date) -> CGFloat {
            let minutes = date.timeIntervalSince(window.start) / 60
            return CGFloat(minutes) * Layout.pixelsPerMinute
        }

        func cardHeight(for appointment: Appointment) -> CGFloat {
            let minutes = appointment.endDate.timeIntervalSince(appointment.startDate) / 60
            return max(CGFloat(minutes) * Layout.pixelsPerMinute, Layout.minCardHeight)
        }

        private static func makeAnchorTimes(for window: WorkingWindow, calendar: Calendar) -> [Date] {
            let components = calendar.dateComponents([.year, .month, .day, .hour], from: window.start)
            guard var hourStart = calendar.date(from: components) else { return [] }

            if hourStart < window.start {
                hourStart = hourStart.addingTimeInterval(3600)
            }

            var times: [Date] = []
            var current = hourStart

            while current <= window.end {
                times.append(current)
                current = current.addingTimeInterval(3600)
            }

            return times
        }
    }

    struct WorkingWindow {
        let start: Date
        let end: Date

        static func calculate(
            appointments: [Appointment],
            currentTime: Date
        ) -> WorkingWindow {
            guard !appointments.isEmpty else {
                return WorkingWindow(
                    start: currentTime.addingTimeInterval(-emptyDayHalfWindow),
                    end: currentTime.addingTimeInterval(emptyDayHalfWindow)
                )
            }

            let firstStart = appointments.min(by: { $0.startDate < $1.startDate })!.startDate
            let lastEnd = appointments.max(by: { $0.endDate < $1.endDate })!.endDate

            var start = firstStart.addingTimeInterval(-windowPadding)
            var end = lastEnd.addingTimeInterval(windowPadding)

            if currentTime < start {
                start = currentTime.addingTimeInterval(-windowPadding)
            }

            if currentTime > end {
                end = currentTime.addingTimeInterval(windowPadding)
            }

            return WorkingWindow(start: start, end: end)
        }

        private static let windowPadding: TimeInterval = 60 * 60
        private static let emptyDayHalfWindow: TimeInterval = 2 * 60 * 60
    }
}


// MARK: - Preview

#Preview("DailyScheduleCanvas — vazio") {
    DailyScheduleCanvas(appointments: [], date: .now) { _ in }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
}

#Preview("DailyScheduleCanvas — com compromissos") {
    let now = Date()
    let past = Appointment(
        startDate: now.addingTimeInterval(-7200),
        endDate: now.addingTimeInterval(-3600),
        status: .finished
    )
    let active = Appointment(
        startDate: now.addingTimeInterval(-600),
        endDate: now.addingTimeInterval(3000),
        status: .confirmed
    )
    let next = Appointment(
        startDate: now.addingTimeInterval(5400),
        endDate: now.addingTimeInterval(9000),
        status: .scheduled
    )
    let blocked = Appointment(
        startDate: now.addingTimeInterval(10800),
        endDate: now.addingTimeInterval(12600),
        status: .blocked
    )

    DailyScheduleCanvas(
        appointments: [past, active, next, blocked],
        date: .now
    ) { _ in }
    .padding(.horizontal)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}
