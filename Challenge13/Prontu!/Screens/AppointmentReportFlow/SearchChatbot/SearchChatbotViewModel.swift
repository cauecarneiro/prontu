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
    private weak var coordinator: (any SearchChatBotCoordinatorProtocol)?
    private var currentReplyTask: Task<Void, Never>?

    init(engine: AppointmentChatEngine, coordinator: (any SearchChatBotCoordinatorProtocol)?) {
        self.engine = engine
        self.coordinator = coordinator
    }

    deinit {
        currentReplyTask?.cancel()
    }

    func sendUserMessage(_ text: String) {
        messages.append(.init(author: .user, text: text))

        loading = true

        currentReplyTask?.cancel()
        currentReplyTask = Task { [weak self] in
            guard let self else { return }
            do {
                let response = try await self.engine.reply(to: text)
                try Task.checkCancellation()
                await MainActor.run {
                    self.messages.append(response)
                    self.loading = false
                }
            } catch is CancellationError {
                return
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
        currentReplyTask?.cancel()
        coordinator?.dismissSearchChatBot()
    }
    
}
