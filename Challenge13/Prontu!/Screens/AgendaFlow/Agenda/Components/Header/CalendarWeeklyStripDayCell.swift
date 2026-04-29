//
//  CalendarWeeklyStripDayCell.swift
//  Challenge13
//
//  Created by Caio Mandarino on 15/04/26.
//

import SwiftUI

struct CalendarWeeklyStripDayCell: View {
    let date: Date
    let isSelected: Bool
    let hasAppointments: Bool
    let namespace: Namespace.ID

    private let calendar = Calendar.current
    private var dayNum: String { date.formatted(.dateTime.day()) }
    private var isToday: Bool { calendar.isDateInToday(date) }

    var body: some View {
        VStack(spacing: Layout.innerSpacing) {
            ZStack {
                if isSelected {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(GlobalConfiguration.primaryBlue)
                        .frame(maxWidth: .infinity)
                        .aspectRatio(1, contentMode: .fit)
                        .matchedGeometryEffect(id: "day-selection", in: namespace)
                }

                if isToday && !isSelected {
                    Text(dayNum)
                        .font(.headline)
                        .foregroundStyle(.primaryBlue)
                        .frame(maxWidth: .infinity, minHeight: Layout.cellSize)
                } else {
                    Text(dayNum)
                        .font(.headline)
                        .foregroundStyle(isSelected ? Color.white : Color.primary)
                        .frame(maxWidth: .infinity, minHeight: Layout.cellSize)
                }

            }
            .scaleEffect(isSelected ? Layout.selectedScale : Layout.unselectedScale)
            .frame(height: Layout.cellSize)

            Circle()
                .fill(hasAppointments ? GlobalConfiguration.primaryBlue : Color.clear)
                .frame(width: Layout.dotSize, height: Layout.dotSize)
        }
    }

    private enum Layout {
        static let cellSize: CGFloat = 40
        static let dotSize: CGFloat = 5
        static let innerSpacing: CGFloat = 4
        static let selectedScale: CGFloat = 1.12
        static let unselectedScale: CGFloat = 0.88
    }
}

#Preview {
    @Previewable @Namespace var namespace
    
    CalendarWeeklyStripDayCell(
        date: .now,
        isSelected: true,
        hasAppointments: true,
        namespace: namespace
    )
}
