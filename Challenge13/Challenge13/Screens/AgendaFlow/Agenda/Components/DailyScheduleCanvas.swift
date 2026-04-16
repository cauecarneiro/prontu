//
//  DailyScheduleCanvas.swift
//  Challenge13
//
//  Created by Caio Mandarino on 15/04/26.
//

import SwiftUI

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
        let window = WorkingWindow.calculate(appointments: activeAppointments, currentTime: currentTime)
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

            ForEach(activeAppointments, id: \.id) { appt in
                ScheduleCard(appointment: appt, state: cardState(for: appt))
                    .frame(
                        width: width - Layout.leftInset - Layout.cardTrailingPadding,
                        height: cardHeight(for: appt)
                    )
                    .offset(x: Layout.leftInset, y: yOffset(for: appt.startDate, window: window))
                    .zIndex(1)
            }

            CurrentTimeNeedle(time: currentTime, width: width, leftInset: Layout.leftInset)
                .offset(y: yOffset(for: currentTime, window: window))
                .id("needle")
                .zIndex(2)
        }
    }

    // MARK: - Computed Properties

    private var activeAppointments: [Appointment] {
        appointments.filter { $0.status != .cancelled }
    }

    // MARK: - Geometry Helpers

    private func canvasHeight(for window: WorkingWindow) -> CGFloat {
        let minutes = window.end.timeIntervalSince(window.start) / 60
        return CGFloat(minutes) * Layout.pixelsPerMinute
    }

    private func anchorTimes(for window: WorkingWindow) -> [Date] {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour], from: window.start)
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
        if currentTime > appointment.endDate { return .past }
        if currentTime >= appointment.startDate { return .active }
        return .standard
    }

    // MARK: - Canvas Focus Management

    private func focusCanvas(proxy: ScrollViewProxy, animated: Bool) {
        let anchor: UnitPoint

        if activeAppointments.isEmpty {
            anchor = .center
        } else if activeAppointments.allSatisfy({ currentTime > $0.endDate }) {
            // Late case: all appointments are past, needle in lower third
            anchor = UnitPoint(x: 0.5, y: 0.7)
        } else {
            // Default and active cases: needle in upper third
            anchor = UnitPoint(x: 0.5, y: 0.25)
        }

        if animated {
            withAnimation(.smooth(duration: 0.4)) {
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
