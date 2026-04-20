//
//  MessageChat.swift
//  Challenge13
//
//  Created by Luciana Liebl de Freitas on 15/04/26.
//

import Foundation

enum ChatAuthor {
    case hero
    case user
}

enum HeroSuggestionType: String, Hashable {
    case checkAvailableTimes
    case nextAppointment
    case todayAgenda
}

struct MessageChat: Identifiable {
    let id = UUID()
    let author: ChatAuthor
    let text: String
    let suggestions: [HeroSuggestion]
    
    init(author: ChatAuthor, text: String){
        self.author = author
        self.text = text
        self.suggestions = HeroSuggestion.suggestions
    }
}

struct HeroSuggestion: Identifiable {
    var id: String { type.rawValue }
    
    let type: HeroSuggestionType
    let title: String
}

extension HeroSuggestion {
    static let suggestions: [HeroSuggestion] = [
        .init(type: .checkAvailableTimes, title: "Ver horários disponíveis"),
        .init(type: .nextAppointment, title: "Ver próximo atendimento"),
        .init(type: .todayAgenda, title: "Resumo da agenda de hoje")
    ]
}
