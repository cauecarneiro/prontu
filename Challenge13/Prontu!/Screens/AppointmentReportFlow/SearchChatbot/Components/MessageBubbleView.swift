//
//  MessageBubbleView.swift
//  Challenge13
//
//  Created by Luciana Liebl de Freitas on 14/04/26.
//
import SwiftUI
import SwiftData

//Bolha de mensagem
struct MessageBubbleView: View{
    //Modelo da mensagem
    let message: MessageChat
    //Callback ao clicar na sugestão
    let onSuggestion: (HeroSuggestion) -> Void
    //Verica se é a IA ou  o user
    private var isHero: Bool{ message.author == .hero }
    
    //Layout da mensagem:
    var body: some View{
        VStack(alignment: isHero ? .leading : .trailing, spacing: 6){
            //Se for IA, bolha de texto à esquerda
            HStack(alignment: .bottom, spacing: 0){
                if isHero{
                    textBubble
                    Spacer(minLength: 52)
                } else{
                    Spacer(minLength: 52)
                    textBubble
                }
            }
            
            if isHero && !message.suggestions.isEmpty{
                ChipsSuggestionsView(suggestions: message.suggestions, onTap: onSuggestion)
                    .padding(.leading, 36)
            }
        }
    }
    
    private var textBubble: some View{
        Text(message.text)
            .font(.body)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(isHero ? Color(.secondarySystemBackground) : Color.accentColor)
            .foregroundStyle(isHero ? Color.primary : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}
