//
//  AppointmentReportCoordinatorProtocol.swift
//  Challenge13
//
//  Created by Caio Mandarino on 03/04/26.
//

import Foundation

protocol AppointmentReportCoordinatorProtocol: AnyObject {
    func presentSearchChatbot(appointments: [Appointment])
    func navigateToClientHistory(client: Client, appointments: [Appointment])
    func navigateToPreferences()
}
