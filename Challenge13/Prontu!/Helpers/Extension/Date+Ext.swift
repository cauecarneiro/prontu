//
//  Date+Ext.swift
//  Challenge13
//
//  Created by Caio Mandarino on 14/04/26.
//

import Foundation

extension Date {
    func formatterRow(calendar: Calendar = .current) -> String {
        let locale = Locale(identifier: "pt_BR")
        
        let dayMonthFormatter = DateFormatter()
        dayMonthFormatter.locale = locale
        dayMonthFormatter.calendar = calendar
        dayMonthFormatter.dateFormat = "d 'de' MMMM"
        
        let weekdayFormatter = DateFormatter()
        weekdayFormatter.locale = locale
        weekdayFormatter.calendar = calendar
        weekdayFormatter.dateFormat = "EEEE"
        
        let dayMonth = dayMonthFormatter.string(from: self)
        
        if calendar.isDateInToday(self) {
            return "Hoje, \(dayMonth)"
        }
        
        if calendar.isDateInYesterday(self) {
            return "Ontem, \(dayMonth)"
        }
        
        if calendar.isDateInTomorrow(self) {
            return "Amanhã, \(dayMonth)"
        }
        
        let weekday = weekdayFormatter.string(from: self)
            .replacingOccurrences(of: "-feira", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        let capitalizedWeekday = weekday.prefix(1).uppercased() + weekday.dropFirst()
        
        return "\(capitalizedWeekday), \(dayMonth)"
    }
    
    var detailsDayText: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "EEE, MMM d"

        return formatter.string(from: self)
            .replacingOccurrences(of: ".", with: "").capitalized(with: Locale(identifier: "pt_BR"))
    }
    
    var detailsHourText: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "HH:mm"
        
        return formatter.string(from: self)
    }
    

}
