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
    @State private var currentPageIndex: Int = 1

    @Namespace private var currentDayNamespace

    private let calendar = Calendar.autoupdatingCurrent

    var body: some View {
        TabView(selection: $currentPageIndex) {
            ForEach(Array(weekPages.enumerated()), id: \.element.id) { index, page in
                WeekPageView(
                    selectedDate: $selectedDate,
                    page: page,
                    namespace: currentDayNamespace,
                    calendar: calendar
                )
                .tag(index)
                .padding(.horizontal)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(maxHeight: 90)
        .onAppear {
            configureInitialPagesIfNeeded()
        }
        .onChange(of: currentPageIndex) { _ , newValue in
            paginateIfNeeded(for: newValue)
        }
    }
}

// MARK: - Paging Logic
extension WeekCalendarView {
    private func configureInitialPagesIfNeeded() {
        guard weekPages.isEmpty else { return }

        let currentWeek = WeekPage(containing: selectedDate, calendar: calendar)
        let previousWeek = WeekPage(containing: calendar.date(byAdding: .weekOfYear, value: -1, to: currentWeek.referenceDate) ?? selectedDate, calendar: calendar)
        let nextWeek = WeekPage(containing: calendar.date(byAdding: .weekOfYear, value: 1, to: currentWeek.referenceDate) ?? selectedDate, calendar: calendar)

        weekPages = [previousWeek, currentWeek, nextWeek]
        currentPageIndex = 1
    }

    private func paginateIfNeeded(for index: Int) {
        guard weekPages.indices.contains(index) else { return }

        if index == 0 {
            appendPreviousWeek()
        }
        
        else if index == weekPages.count - 1 {
            appendNextWeek()
        }
    }
    
    private func appendPreviousWeek() {
        guard let firstReference = weekPages.first?.referenceDate,
              let newReference = calendar.date(byAdding: .weekOfYear, value: -1, to: firstReference)
        else { return }

        let newPage = WeekPage(containing: newReference, calendar: calendar)

        weekPages.insert(newPage, at: 0)

        if weekPages.count > 3 {
            weekPages.removeLast()
        }

        withTransaction(Transaction(animation: nil)) {
            currentPageIndex = 1
        }
    }
    
    private func appendNextWeek() {
        guard let lastReference = weekPages.last?.referenceDate,
              let newReference = calendar.date(byAdding: .weekOfYear, value: 1, to: lastReference)
        else { return }

        let newPage = WeekPage(containing: newReference, calendar: calendar)

        weekPages.append(newPage)

        if weekPages.count > 3 {
            weekPages.removeFirst()
        }

        withTransaction(Transaction(animation: nil)) {
            currentPageIndex = 1
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
