//
//  AgendaCoordinateProtocol.swift
//  Challenge13
//
//  Created by Caio Mandarino on 01/04/26.
//

import Foundation

protocol AgendaCoordinateProtocol: AnyObject {
    func navigateToCreateAppointment()
    func navigateToAppointmentDetails(appointment: Appointment)
}

