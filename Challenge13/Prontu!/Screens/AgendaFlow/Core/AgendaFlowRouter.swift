//
//  AgendaFlowRouter.swift
//  Challenge13
//
//  Created by Caio Mandarino on 01/04/26.
//

import Foundation

enum AgendaFlowRouter: Hashable & Identifiable {
    var id: String { String(describing: self) }
    
    case createAppointment
    case createClient
    case selectedClient
    case generateEquipaments
    case editAppointment(Appointment)
    case appointmentDetails(UUID)
}
