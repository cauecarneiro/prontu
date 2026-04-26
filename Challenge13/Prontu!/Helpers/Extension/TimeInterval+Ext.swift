//
//  TimeInterval+Ext.swift
//  Challenge13
//
//  Created by Caio Mandarino on 23/04/26.
//

import Foundation

extension TimeInterval {
    var formattedDuration: String {
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = [.dropLeading, .dropTrailing]
        
        return formatter.string(from: self) ?? "0m"
    }
}
