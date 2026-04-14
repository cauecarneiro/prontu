//
//  WeekDay.swift
//  Challenge13
//
//  Created by Caio Mandarino on 13/04/26.
//

import Foundation

struct WeekDay: Identifiable, Hashable {
    let date: Date

    var id: Date {
        date
    }
    
    func formattedWeekDay() -> String {
        let weekDay = Calendar.current.component(.weekday, from: date)
        
        switch weekDay {
        case 1:
            return "D"
        case 2:
            return "S"
        case 3:
            return "T"
        case 4...5:
            return "Q"
        case 6...7:
            return "S"
        default:
            return "?"
        }
    }
}
