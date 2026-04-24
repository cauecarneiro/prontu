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
            text: "Olá! Sou o Assistente, seu analista de dados. Como posso ajudar?" // TODO: Ver quando tiver o nome do app e alterar aqui
        )
    ]
    
    var canSend: Bool {
        !typedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !loading
    }
    
    private let engine: AppointmentChatEngine
    private weak var coordinator: (any SeachChatBotCoordinatorProtocol)?
    
    init(engine: AppointmentChatEngine, coordinator: (any SeachChatBotCoordinatorProtocol)?) {
        self.engine = engine
        self.coordinator = coordinator
    }
    
    func sendUserMessage(_ text: String) {
        messages.append(.init(author: .user, text: text))
        
        loading = true
        
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
                    self.loading = false
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
    
    func dismiss() {
        coordinator?.dismissSearchChatBot()
    }
    
}
