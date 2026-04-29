//
//  AppointmentReportFlowRouter.swift
//  Challenge13
//
//  Created by Caio Mandarino on 03/04/26.
//

import Foundation

enum AppointmentReportFlowRouter: Hashable, Identifiable {
    var id: String { String(describing: self) }
    
    case searchChatBot([Appointment])
    case clientHistory(Client, [Appointment])
    case preferences
}
