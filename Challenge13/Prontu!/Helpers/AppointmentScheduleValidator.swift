//
//  AppointmentScheduleValidator.swift
//  Challenge13
//
//  Created by Codex on 26/04/26.
//

import Foundation

enum AppointmentScheduleValidator {
    private static let secondsPerMinute: TimeInterval = 60

    static func combine(date: Date, time: Date) -> Date {
        let calendar = Calendar.current

        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)

        var final = DateComponents()
        final.year = dateComponents.year
        final.month = dateComponents.month
        final.day = dateComponents.day
        final.hour = timeComponents.hour
        final.minute = timeComponents.minute

        return calendar.date(from: final) ?? date
    }

    static func endDate(startDate: Date, duration: Int) -> Date {
        Calendar.current.date(
            byAdding: .minute,
            value: duration,
            to: startDate
        ) ?? startDate
    }

    static func durationInMinutes(from startDate: Date, to endDate: Date) -> Int {
        Int(startDate.distance(to: endDate) / secondsPerMinute)
    }

    static func hasConflict(
        databaseService: DatabaseService,
        from startDate: Date,
        to endDate: Date,
        ignoring appointmentID: UUID? = nil
    ) -> Bool {
        databaseService
            .fetchOverlappingAppointments(from: startDate, to: endDate)
            .contains { appointment in
                guard let appointmentID else {
                    return true
                }

                return appointment.id != appointmentID
            }
    }
}
