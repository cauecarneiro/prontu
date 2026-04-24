//
//  CalendarWeeklyStripWeekdayRow.swift
//  Challenge13
//
//  Created by Caio Mandarino on 15/04/26.
//

import SwiftUI

struct CalendarWeeklyStripWeekdayRow: View {
    let weekDates: [Date]

    private let locale = Locale(identifier: "pt-BR")

    var body: some View {
        HStack(spacing: .zero) {
            ForEach(Array(weekDates.enumerated()), id: \.offset) { _, date in
                Text(date.formatted(.dateTime.weekday(.narrow).locale(locale)).uppercased())
                    .font(.system(size: Layout.fontSize, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, GlobalConfiguration.normalSpacing)
    }

    private enum Layout {
        static let fontSize: CGFloat = 12
    }
}

#Preview {
    let calendar = Calendar.current
    let today = Date()
    let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
    let dates = (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: weekStart) }

    CalendarWeeklyStripWeekdayRow(weekDates: dates)
        .padding(.vertical)
}
