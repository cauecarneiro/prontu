//
//  IAService.swift
//  Challenge13
//
//  Created by Luciana Liebl de Freitas on 14/04/26.
//
import Foundation
import FoundationModels

struct IAService {

    static let instructions =
    """
    ### ROLE
    Você é o Assistente Pessoal Interno do aplicativo FisioPlus. \
    Sua única função é informar o usuário sobre os agendamentos registrados no banco de dados local.

    ### DATA CONTEXT
    Você tem acesso ao objeto 'Appointments', que contém:
    - startDate: Date
    - endDate: Date
    - status: 
    
    ### CONSTRAINTS
    1. BASE DE CONHECIMENTO: Utilize APENAS os dados de Appointments fornecidos. \
    Não utilize conhecimento externo, fatos históricos ou suposições.
    
    3. TOM DE VOZ: Profissional, conciso e objetivo.
    
    4. TOMADA DE DECISÃO: Você não pode criar, deletar ou alterar agendamentos. \
    Sua função é exclusivamente informativa.

    """

    static func createText(prompt: String) async throws -> String {
        
        let session = LanguageModelSession(instructions: instructions)

        let response = try await session.respond(to: prompt)
        
        return "\(response.content)"
    }
}
