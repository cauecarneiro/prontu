//
//  Client.swift
//  Challenge13
//
//  Created by Caio Mandarino on 03/04/26.
//

import SwiftData
import Foundation

@Model
final class Client {
    
    @Attribute(.unique)
    var id: UUID = UUID()
    
    var name: String
    var contactInfo: String
    var observations: String?
    
    @Relationship(deleteRule: .cascade, inverse: \Appointment.client)
    var appointments: [Appointment] = []
    
    init(
        name: String,
        contactInfo: String,
        observations: String? = nil,
    ) { 
        self.name = name
        self.contactInfo = contactInfo
        self.observations = observations
    }
    
}

extension Client {
    
    var initials: String {
        // Divide o nome em partes (ex: "Ana Costa" → ["Ana", "Costa"])
        let nomes = name.split(separator: " ")
        
        // Pega a primeira letra do primeiro nome
        let primeira = nomes.first?.prefix(1) ?? ""
        
        // Pega a primeira letra do segundo nome (se existir)
        let segunda = nomes.dropFirst().first?.prefix(1) ?? ""
        
        // Converte Substring → String e concatena
        return String(primeira) + String(segunda)
    }
}
