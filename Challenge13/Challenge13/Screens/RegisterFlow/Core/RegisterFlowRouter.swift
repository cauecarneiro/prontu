//
//  RegisterFlowRouter.swift
//  Challenge13
//
//  Created by Caio Mandarino on 03/04/26.
//

import Foundation

enum RegisterFlowRouter: Hashable, Identifiable {
    var id: String { String(describing: self)}
    
    case createClient
    case editClient(Client)
}
