//
//  MessageChat.swift
//  Challenge13
//
//  Created by Luciana Liebl de Freitas on 15/04/26.
//

import Foundation

//MARK: quem é o autor da mensagem
enum ChatAuthor {
    case hero
    case user
}

//MARK: opções do que o usuário quer que seja respondido
//Nesse enum cada case tem um valor interno do tipo String
enum HeroSuggestionType: String, Hashable {
    case checkAvailableTimes
}

//MARK: mensagem do chat
struct MessageChat: Identifiable, Hashable {
    let id = UUID()
    let author: ChatAuthor
    let text: String
    let suggestions: [HeroSuggestion]
    
    init(author: ChatAuthor, text: String, suggestions: [HeroSuggestion] = []){
        self.author = author
        self.text = text
        self.suggestions = suggestions
    }
}

//MARK: botão clicável
//Protocolo Identifiable cada objeto deve ter um identificador único
//Protocolo Hashable o objeto pode virar um hash, um identificador único
struct HeroSuggestion: Identifiable, Hashable {
    //Qual opção o usuário quer
    let type: HeroSuggestionType
    //Texto mostrado
    let title: String
    //ID da opção
    //O protocolo Identifiable exige essa a implementação de um ID
    //rawValue diz que o ID será o texto do enum HeroSuggestionType
    var id: String { type.rawValue }
}
