//
//  AgendaFlowRouter.swift
//  Challenge13
//
//  Created by Caio Mandarino on 01/04/26.
//

import Foundation

enum AgendaFlowRouter: Hashable {
    case createAppointment
    case editAppointment(Appointment)
    case appointmentDetails(Appointment)
}
