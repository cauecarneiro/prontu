//
//  Client.swift
//  Challenge13
//
//  Created by Caio Mandarino on 03/04/26.
//

import SwiftData
import Foundation

@Model
final class Client { // nunca apagar o client, mudar para o isDeleted para true
    
    @Attribute(.unique)
    var id: UUID = UUID()
    
    var name: String
    var contactInfo: String
    var birthday: Date?
    var observations: String?
    var isDeleted: Bool = false
    
    @Relationship(deleteRule: .nullify, inverse: \Appointment.client)
    var appointments: [Appointment] = []
    
    init(
        name: String = "",
        contactInfo: String = "",
        birthday: Date? = nil,
        observations: String? = nil,
    ) { // TODO: alterar o init para tirar os valores defaults
        self.name = name
        self.contactInfo = contactInfo
        self.birthday = birthday
        self.observations = observations
    }
    
    //Função que prepara os dados para Foundations entende. Pega o objeto e descreve ele em forma de texto
//    func describe() -> String {
//        let formatter = ISO8601DateFormatter()
//        
//        //Se tiver data, formata a data, se não diver data mostra texto padrão
//        /* let birthdayText = birthday.map { formatter.string(from: $0) } ?? "Não informado"
//        let observationsText = observations ?? "Sem observações"
//        - Contato: \(contactInfo)
//        - Data de nascimento: \(birthdayText)
//        - Observações: \(observationsText) */
//        
//        return """
//        Cliente:
//        - Nome: \(name)
//        - Total de agendamentos: \(appointments.count) 
//        """
//    }
}
