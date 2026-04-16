//
//  DailyScheduleCanvas.swift
//  Challenge13
//
//  Created by Caio Mandarino on 15/04/26.
//

import SwiftUI
import Combine

// MARK: - WorkingWindow

struct WorkingWindow {
    let start: Date
    let end: Date

    /// Calculates the time window to render, following the four rules from the design spec:
    /// - Upper bound: first appointment start - 60 min (recedes if currentTime is earlier)
    /// - Lower bound: last appointment end + 60 min (expands if currentTime is later)
    /// - Empty day: 4-hour window centered on currentTime
    /// - Invariant: currentTime is always within the window
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

        var windowStart = firstStart.addingTimeInterval(-windowPadding)
        var windowEnd = lastEnd.addingTimeInterval(windowPadding)

        if currentTime < windowStart {
            windowStart = currentTime.addingTimeInterval(-windowPadding)
        }
        if currentTime > windowEnd {
            windowEnd = currentTime.addingTimeInterval(windowPadding)
        }

        return WorkingWindow(start: windowStart, end: windowEnd)
    }

    private static let windowPadding: TimeInterval = 60 * 60
    private static let emptyDayHalfWindow: TimeInterval = 2 * 60 * 60
}

// MARK: - DailyScheduleCanvas

struct DailyScheduleCanvas: View {
    let appointments: [Appointment]
    let date: Date

    @State private var currentTime: Date = .now

    private let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()

    var body: some View {
        GeometryReader { geo in
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    canvas(width: geo.size.width)
                }
                .onAppear {
                    focusCanvas(proxy: proxy, animated: false)
                }
                .onChange(of: date) {
                    currentTime = Date()
                    focusCanvas(proxy: proxy, animated: true)
                }
                .onReceive(timer) { _ in
                    currentTime = Date()
                }
            }
        }
    }

    // MARK: - Canvas Layout

    @ViewBuilder
    private func canvas(width: CGFloat) -> some View {
        let window = WorkingWindow.calculate(appointments: appointmentsForDisplay, currentTime: timelineNow)
        let height = canvasHeight(for: window)
        let marks = anchorTimes(for: window)

        ZStack(alignment: .topLeading) {
            Color.clear
                .frame(width: width, height: height)

            ForEach(marks, id: \.self) { time in
                AnchorTimeMark(time: time, leftInset: Layout.leftInset)
                    .frame(width: width)
                    .offset(y: yOffset(for: time, window: window))
            }

            ForEach(appointmentsForDisplay, id: \.id) { appt in
                ScheduleCard(appointment: appt, state: cardState(for: appt))
                    .frame(
                        width: max(width - Layout.leftInset - Layout.cardTrailingPadding, Layout.minCardWidth),
                        height: cardHeight(for: appt)
                    )
                    .offset(x: Layout.leftInset, y: yOffset(for: appt.startDate, window: window))
                    .zIndex(1)
            }

            CurrentTimeNeedle(time: timelineNow, width: width, leftInset: Layout.leftInset)
                .offset(y: yOffset(for: timelineNow, window: window))
                .id("needle")
                .zIndex(2)
        }
    }

    // MARK: - Computed Properties

    private var activeAppointments: [Appointment] {
        appointments.filter { $0.status != .cancelled }
            .sorted(by: { $0.startDate < $1.startDate })
    }

    private var appointmentsForDisplay: [Appointment] {
        activeAppointments.isEmpty ? placeholderAppointments : activeAppointments
    }

    private var placeholderAppointments: [Appointment] {
        [
            Appointment(
                startDate: dayTime(hour: 8, minute: 0),
                endDate: dayTime(hour: 8, minute: 50),
                status: .confirmed,
                client: Client(name: "Aula de Pilates")
            ),
            Appointment(
                startDate: dayTime(hour: 10, minute: 0),
                endDate: dayTime(hour: 10, minute: 45),
                status: .pending,
                client: Client(name: "Aula Funcional")
            ),
            Appointment(
                startDate: dayTime(hour: 12, minute: 30),
                endDate: dayTime(hour: 13, minute: 0),
                status: .blocked
            ),
            Appointment(
                startDate: dayTime(hour: 16, minute: 0),
                endDate: dayTime(hour: 16, minute: 50),
                status: .finished,
                client: Client(name: "Aula de Mobilidade")
            )
        ]
        .sorted(by: { $0.startDate < $1.startDate })
    }

    private var timelineNow: Date {
        let calendar = Calendar.current
        guard !calendar.isDateInToday(date) else { return currentTime }

        let time = calendar.dateComponents([.hour, .minute], from: currentTime)
        var day = calendar.dateComponents([.year, .month, .day], from: date)
        day.hour = time.hour
        day.minute = time.minute
        return calendar.date(from: day) ?? date
    }

    private func dayTime(hour: Int, minute: Int) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        components.hour = hour
        components.minute = minute
        return calendar.date(from: components) ?? date
    }

    // MARK: - Geometry Helpers

    private func canvasHeight(for window: WorkingWindow) -> CGFloat {
        let minutes = window.end.timeIntervalSince(window.start) / 60
        return CGFloat(minutes) * Layout.pixelsPerMinute
    }

    private func anchorTimes(for window: WorkingWindow) -> [Date] {
        let calendar = Calendar.current
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

    private func yOffset(for date: Date, window: WorkingWindow) -> CGFloat {
        let minutes = date.timeIntervalSince(window.start) / 60
        return CGFloat(minutes) * Layout.pixelsPerMinute
    }

    private func cardHeight(for appointment: Appointment) -> CGFloat {
        let minutes = appointment.endDate.timeIntervalSince(appointment.startDate) / 60
        return max(CGFloat(minutes) * Layout.pixelsPerMinute, Layout.minCardHeight)
    }

    // MARK: - Card State

    private func cardState(for appointment: Appointment) -> ScheduleCardState {
        if timelineNow > appointment.endDate { return .past }
        if timelineNow >= appointment.startDate { return .active }
        return .standard
    }

    // MARK: - Canvas Focus Management

    private func focusCanvas(proxy: ScrollViewProxy, animated: Bool) {
        let anchor: UnitPoint
        let referenceTime = timelineNow

        if appointmentsForDisplay.isEmpty {
            anchor = .center
        } else if appointmentsForDisplay.contains(where: { appointment in
            referenceTime >= appointment.startDate && referenceTime <= appointment.endDate
        }) {
            // Active case: current time sits inside an appointment.
            anchor = UnitPoint(x: Layout.anchorX, y: Layout.activeAnchorY)
        } else if appointmentsForDisplay.contains(where: { $0.startDate > referenceTime }) {
            // Default case: show current needle and the next appointment.
            anchor = UnitPoint(x: Layout.anchorX, y: Layout.defaultAnchorY)
        } else {
            // Late case: all appointments are past, needle in lower third
            anchor = UnitPoint(x: Layout.anchorX, y: Layout.lateAnchorY)
        }

        if animated {
            withAnimation(.smooth(duration: Layout.focusAnimationDuration)) {
                proxy.scrollTo("needle", anchor: anchor)
            }
        } else {
            proxy.scrollTo("needle", anchor: anchor)
        }
    }

    // MARK: - Layout

    private enum Layout {
        static let pixelsPerMinute: CGFloat = 4.0
        static let leftInset: CGFloat = 52
        static let cardTrailingPadding: CGFloat = GlobalConfiguration.normalSpacing
        static let minCardHeight: CGFloat = 24
        static let minCardWidth: CGFloat = 120
        static let anchorX: CGFloat = 0.5
        static let defaultAnchorY: CGFloat = 0.25
        static let activeAnchorY: CGFloat = 0.3
        static let lateAnchorY: CGFloat = 0.7
        static let focusAnimationDuration: Double = 0.4
    }
}

// MARK: - Preview

#Preview("DailyScheduleCanvas — vazio") {
    DailyScheduleCanvas(appointments: [], date: .now)
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
        status: .pending
    )
    let blocked = Appointment(
        startDate: now.addingTimeInterval(10800),
        endDate: now.addingTimeInterval(12600),
        status: .blocked
    )

    DailyScheduleCanvas(
        appointments: [past, active, next, blocked],
        date: .now
    )
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}
