//
//  Appointment.swift
//  Challenge13
//
//  Created by Caio Mandarino on 01/04/26.
//

import SwiftData
import Foundation

@Model
final class Appointment {
    
    @Attribute(.unique)
    var id: UUID = UUID()
    
    var startDate: Date
    var endDate: Date
    var status: AppointmentStatus
    
    var client: Client?
    
    var exercises: String?
    var equipment: String?
    var notes: String?
    
    init(
        id: UUID = UUID(),
        startDate: Date,
        endDate: Date,
        status: AppointmentStatus = .scheduled,
        client: Client? = nil,
        exercises: String? = nil,
        equipment: String? = nil,
        notes: String? = nil
    ) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.status = status
        self.client = client
        self.exercises = exercises
        self.equipment = equipment
        self.notes = notes
    }
}

