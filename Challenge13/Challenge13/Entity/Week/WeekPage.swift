//
//  WeekPage.swift
//  Challenge13
//
//  Created by Caio Mandarino on 13/04/26.
//

import Foundation

struct WeekPage: Identifiable, Hashable {
    let referenceDate: Date
    let days: [WeekDay]

    var id: Date {
        referenceDate
    }

    init(containing date: Date, calendar: Calendar) {
        let normalized = calendar.startOfDay(for: date)
        self.referenceDate = normalized
        self.days = Self.makeWeek(containing: normalized, calendar: calendar)
    }

    private static func makeWeek(containing date: Date, calendar: Calendar) -> [WeekDay] {
        guard let interval = calendar.dateInterval(of: .weekOfYear, for: date) else {
            return []
        }

        let startOfWeek = interval.start

        return (0..<7).compactMap { offset in
            guard let day = calendar.date(byAdding: .day, value: offset, to: startOfWeek) else {
                return nil
            }
            return WeekDay(date: calendar.startOfDay(for: day))
        }
    }
}


