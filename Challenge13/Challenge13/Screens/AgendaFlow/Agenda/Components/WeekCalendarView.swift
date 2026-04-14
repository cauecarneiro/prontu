//
//  WeekCalendarView.swift
//  Challenge13
//
//  Created by Caio Mandarino on 13/04/26.
//

import SwiftUI

struct WeekCalendarView: View {
    @Binding var selectedDate: Date
    
    @State private var weekPages: [WeekPage] = []
    @State private var visibleWeekID: WeekPage.ID?
    
    @Namespace private var currentDayNamespace
    
    private let calendar = Calendar.autoupdatingCurrent
    private let centeredPageIndex = 2
    
    var body: some View {
            ScrollView(.horizontal) {
                LazyHStack(spacing: .zero) {
                    ForEach(weekPages) { page in
                        WeekPageView(
                            selectedDate: $selectedDate,
                            page: page,
                            namespace: currentDayNamespace,
                            calendar: calendar
                        )
                        .containerRelativeFrame(.horizontal)
                        .id(page.id)
                    }
                }
                .scrollTargetLayout()
            }
            .frame(maxHeight: 90)
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: $visibleWeekID)
            .onAppear {
                configureInitialPagesIfNeeded()
            }
            .onScrollPhaseChange { _, newPhase in
                guard newPhase == .idle else { return }
                paginateIfNeeded()
            }
        
    }
}

// MARK: - Paging Logic
extension WeekCalendarView {
    private func configureInitialPagesIfNeeded() {
        guard weekPages.isEmpty else { return }
        
        let centeredWeek = WeekPage(containing: selectedDate, calendar: calendar)
        weekPages = makeBuffer(around: centeredWeek.referenceDate)
        visibleWeekID = weekPages[centeredPageIndex].id
    }
    
    private func paginateIfNeeded() {
        guard let visibleWeekID,
              let visibleIndex = weekPages.firstIndex(where: { $0.id == visibleWeekID })
        else { return }
        
        
        if visibleIndex != 2 {
            let centeredReferenceDate = weekPages[visibleIndex].referenceDate
            weekPages = makeBuffer(around: centeredReferenceDate)
            
            self.visibleWeekID = weekPages[centeredPageIndex].id
        }
    }
    
    private func makeBuffer(around referenceDate: Date) -> [WeekPage] {
        (-2...2).compactMap { offset in
            guard let pageReferenceDate = calendar.date(byAdding: .weekOfYear, value: offset, to: referenceDate) else {
                return nil
            }
            
            return WeekPage(containing: pageReferenceDate, calendar: calendar)
        }
    }
}

#Preview {
    @Previewable @State var selectedDate: Date = .init()
    
    VStack(spacing: 20) {
        WeekCalendarView(selectedDate: $selectedDate)
        
        Text(_selectedDate.wrappedValue, format: .dateTime.day().month().year())
            .font(.headline)
    }
    .padding()
}
