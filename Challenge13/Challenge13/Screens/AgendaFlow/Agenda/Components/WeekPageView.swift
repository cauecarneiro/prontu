//
//  WeekPageView.swift
//  Challenge13
//
//  Created by Caio Mandarino on 13/04/26.
//

import SwiftUI

struct WeekPageView: View { // TODO: Mudar a cor
    @Binding var selectedDate: Date
    
    let page: WeekPage
    let namespace: Namespace.ID
    let calendar: Calendar

    var body: some View {
        HStack {
            
            ForEach(page.days) { day in
                let isSelected = calendar.isDate(day.date, inSameDayAs: selectedDate)
                let isToday = calendar.isDateInToday(day.date)

                Button {
                    withAnimation(.spring) {
                        selectedDate = day.date
                    }
                } label: {
                    VStack {
                        Text(day.formattedWeekDay()) 
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        ZStack {
                            if isSelected {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.primary)
                                    .matchedGeometryEffect(
                                        id: "current-day-highlight",
                                        in: namespace
                                    )
                            }

                            Text(day.date, format: .dateTime.day())
                                .font(.headline)
                                .foregroundStyle(isSelected ? .white : .primary) // TODO: Mudar o white para o oposto do background
                                .frame(maxWidth: .infinity, minHeight: 40)
                        }
                        .frame(height: 40)

                        Circle()
                            .fill(isToday ? Color.primary : Color.clear)
                            .frame(width: 5, height: 5)
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    @Previewable @Namespace var currentDayNamespace
    
    WeekPageView(
        selectedDate: .constant(.now),
        page: .init(containing: .now, calendar: .autoupdatingCurrent),
        namespace: currentDayNamespace,
        calendar: .autoupdatingCurrent
    )
}
