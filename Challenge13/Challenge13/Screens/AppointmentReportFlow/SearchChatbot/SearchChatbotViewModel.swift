//
//  SearchChatbotViewModel.swift
//  Challenge13
//
//  Created by Caio Mandarino on 01/04/26.
//

import Combine
import SwiftData
import SwiftUI

//MARK: View Model
class SearchChatbotViewModel: ObservableObject {
        
    @Published var typedText: String = ""
    @Published var loading: Bool = false
    @Published var messages: [MessageChat] = [
        MessageChat(
            author: .hero,
            text: "Olá! Sou o Hero, seu assistente de agendamentos do FisioPlus. Posso te ajudar com informações sobre seus agendamentos. Como posso te ajudar?" // TODO: Ver quando tiver o nome do app e alterar aqui
        )
    ]
    
    var canSend: Bool {
        !typedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !loading
    }
    private let engine: AppointmentChatEngine
    
    
    init(engine: AppointmentChatEngine) {
        self.engine = engine
    }
    
    func sendUserMessage(_ text: String) {
        messages.append(.init(author: .user, text: text))
        
        Task {
            do {
                let response = try await engine.reply(to: text)
                await MainActor.run {
                    self.messages.append(response)
                }
            } catch {
                await MainActor.run {
                    self.messages.append(
                        .init(
                            author: .hero,
                            text: "Não consegui consultar a agenda agora."
                        )
                    )
                }
            }
        }
    }
    
    func sendSuggestion(_ suggestion: HeroSuggestion) {
        switch suggestion.type {
        case .checkAvailableTimes:
            sendUserMessage("Quais horários estão disponíveis?")
        case .nextAppointment:
            sendUserMessage("Qual é meu próximo atendimento?")
        case .todayAgenda:
            sendUserMessage("Como está minha agenda de hoje?")
        }
    }
    
}
