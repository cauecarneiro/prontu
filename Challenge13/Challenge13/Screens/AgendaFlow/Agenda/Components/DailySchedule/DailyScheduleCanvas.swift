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

    @State private var currentTime: Date = .now

    private let calendar = Calendar.autoupdatingCurrent
    private let timelineFocusID = "timeline-focus"

    private var visibleAppointments: [Appointment] {
        appointments
            .filter { $0.status != .cancelled }
            .sorted(by: { $0.startDate < $1.startDate })
    }

    private var timelineNow: Date {
        guard calendar.isDateInToday(date) else {
            let time = calendar.dateComponents([.hour, .minute], from: currentTime)
            var day = calendar.dateComponents([.year, .month, .day], from: date)
            day.hour = time.hour
            day.minute = time.minute
            return calendar.date(from: day) ?? date
        }

        return currentTime
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { proxy in
                ScrollView(.vertical) {
                    canvas(width: geometry.size.width)
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

    // MARK: - Canvas

    @ViewBuilder
    private func canvas(width: CGFloat) -> some View {
        let window = WorkingWindow.calculate(
            appointments: visibleAppointments,
            currentTime: timelineNow
        )
        let canvasHeight = canvasHeight(for: window)
        let marks = anchorTimes(for: window)

        ZStack(alignment: .topLeading) {
            Color.clear
                .frame(width: width, height: canvasHeight)

            anchorMarksLayer(
                marks: marks,
                width: width,
                canvasHeight: canvasHeight,
                window: window
            )

            appointmentsLayer(
                width: width,
                canvasHeight: canvasHeight,
                window: window
            )

            if calendar.isDateInToday(date) {
                focusAnchorLayer(
                    width: width,
                    canvasHeight: canvasHeight,
                    window: window
                )

                currentTimeNeedleLayer(
                    width: width,
                    canvasHeight: canvasHeight,
                    window: window
                )
            }
        }
    }

    // MARK: - Layers

    @ViewBuilder
    private func anchorMarksLayer(
        marks: [Date],
        width: CGFloat,
        canvasHeight: CGFloat,
        window: WorkingWindow
    ) -> some View {
        ForEach(marks, id: \.self) { time in
            positionedLayer(
                y: yOffset(for: time, window: window),
                canvasHeight: canvasHeight,
                width: width
            ) {
                AnchorTimeMark(time: time, leftInset: Layout.leftInset)
                    .frame(width: width, alignment: .leading)
            }
        }
    }

    @ViewBuilder
    private func appointmentsLayer(
        width: CGFloat,
        canvasHeight: CGFloat,
        window: WorkingWindow
    ) -> some View {
        ForEach(visibleAppointments, id: \.id) { appointment in
            positionedLayer(
                y: yOffset(for: appointment.startDate, window: window),
                canvasHeight: canvasHeight,
                width: width
            ) {
                HStack(alignment: .top, spacing: 0) {
                    Color.clear
                        .frame(width: Layout.leftInset)

                    ScheduleCard(
                        appointment: appointment,
                        state: cardState(for: appointment)
                    )
                    .frame(
                        width: cardWidth(for: width),
                        height: cardHeight(for: appointment),
                        alignment: .topLeading
                    )

                    Spacer(minLength: 0)
                }
            }
        }
    }

    @ViewBuilder
    private func focusAnchorLayer(
        width: CGFloat,
        canvasHeight: CGFloat,
        window: WorkingWindow
    ) -> some View {
        positionedLayer(
            y: yOffset(for: timelineNow, window: window),
            canvasHeight: canvasHeight,
            width: width
        ) {
            Color.clear
                .frame(width: width, height: 1)
                .id(timelineFocusID)
        }
    }

    @ViewBuilder
    private func currentTimeNeedleLayer(
        width: CGFloat,
        canvasHeight: CGFloat,
        window: WorkingWindow
    ) -> some View {
        positionedLayer(
            y: yOffset(for: timelineNow, window: window),
            canvasHeight: canvasHeight,
            width: width
        ) {
            CurrentTimeNeedle(
                time: timelineNow,
                width: width,
                leftInset: Layout.leftInset
            )
            .frame(width: width, alignment: .leading)
        }
    }

    @ViewBuilder
    private func positionedLayer<Content: View>(
        y: CGFloat,
        canvasHeight: CGFloat,
        width: CGFloat,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(spacing: 0) {
            Color.clear
                .frame(height: max(y, 0))

            content()

            Spacer(minLength: 0)
        }
        .frame(width: width, height: canvasHeight, alignment: .topLeading)
    }

    // MARK: - Geometry

    private func canvasHeight(for window: WorkingWindow) -> CGFloat {
        let minutes = window.end.timeIntervalSince(window.start) / 60
        return CGFloat(minutes) * Layout.pixelsPerMinute
    }

    private func anchorTimes(for window: WorkingWindow) -> [Date] {
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

    private func cardWidth(for canvasWidth: CGFloat) -> CGFloat {
        max(
            canvasWidth - Layout.leftInset - Layout.cardTrailingPadding,
            Layout.minCardWidth
        )
    }

    // MARK: - Card State

    private func cardState(for appointment: Appointment) -> ScheduleCardState {
        if timelineNow > appointment.endDate { return .past }
        if timelineNow >= appointment.startDate { return .active }
        return .standard
    }

    // MARK: - Focus

    private func focusCanvas(proxy: ScrollViewProxy) {
        guard calendar.isDateInToday(date) else { return }
        
        withAnimation(.smooth(duration: Layout.focusAnimationDuration)) {
            proxy.scrollTo(timelineFocusID, anchor: .center)
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

    // MARK: - WorkingWindow

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
    )
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}
