//
//  AppointmentIntentClassifierService.swift
//  Challenge13
//
//  Created by Caio Mandarino on 18/04/26.
//

import Foundation
import FoundationModels

@Generable
enum AppointmentIntent {
    case checkAvailableTimes
    case nextAppointment
    case todayAgenda
    case unsupported
}

struct AppointmentIntentClassifier {
    func classify(_ userText: String, now: Date = .now) async throws -> AppointmentIntent {
        let session = LanguageModelSession(
            instructions: """
            Você classifica perguntas de agenda em uma única intenção.

            Regras:
            - Retorne apenas uma intenção.
            - Use .checkAvailableTimes para perguntas sobre horários livres, vagas, disponibilidade.
            - Use .nextAppointment para perguntas sobre próximo atendimento, próxima consulta, próximo horário marcado.
            - Use .todayAgenda para perguntas sobre agenda de hoje, compromissos de hoje, atendimentos de hoje.
            - Use .unsupported se a pergunta não se encaixar nas categorias acima.

            Exemplos:
            - "Quais horários tenho livres amanhã?" -> checkAvailableTimes
            - "Qual meu próximo atendimento?" -> nextAppointment
            - "Como está minha agenda hoje?" -> todayAgenda
            - "Resuma meu cliente João" -> unsupported
            """
        )

        let response = try await session.respond(
            generating: AppointmentIntent.self,
            options: GenerationOptions(sampling: .greedy)
        ) {
            """
            Data atual: \(now.formatted(date: .complete, time: .shortened))
            Pergunta do usuário: \(userText)
            """
        }

        return response.content
    }
}
