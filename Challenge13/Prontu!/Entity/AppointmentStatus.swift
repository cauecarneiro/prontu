//
//  AppointmentStatus.swift
//  Challenge13
//
//  Created by Caio Mandarino on 07/04/26.
//

import Foundation

enum AppointmentStatus: String, Codable {
    case scheduled
    case confirmed
    case cancelled
    case finished
    case blocked
}
