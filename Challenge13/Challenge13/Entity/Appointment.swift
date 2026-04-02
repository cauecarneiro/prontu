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
    @Attribute(.unique) var id: UUID
 
    init(id: UUID = UUID()) {
        self.id = id
    }
}
