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
            HStack(alignment: .top, spacing: 10){
                if isHero{
                    AvatarView()
                    textBubble
                   // Spacer(minLength: 5)
                } else{
                   // Spacer(minLength: 5)
                    textBubble
                }
            }
            .padding(10)
            
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
            .background(isHero ? Color(.systemFill).opacity(0.55) : Color(GlobalConfiguration.primaryBlue))
          //  .background(Color(.systemFill).opacity(Layout.secondaryButtonOpacity))
            .foregroundStyle(isHero ? Color.secondary : Color.white)
            //.clipShape(RoundedRectangle(cornerRadius: GlobalConfiguration.normalCornerRadius, style: .continuous))
            .clipShape(RoundedRectangle(cornerRadius: GlobalConfiguration.normalCornerRadius))
    }
}

