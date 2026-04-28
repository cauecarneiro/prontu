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
    //Callback chamado a cada palavra revelada na animação de streaming (apenas hero)
    var onStreamTick: (() -> Void)? = nil
    //Quando true, a mensagem aparece sem animação de streaming
    var skipAnimation: Bool = false
    //Verica se é a IA ou  o user
    private var isHero: Bool{ message.author == .hero }

    // Largura animada do clip mask do bubble (apenas hero animado)
    @State private var bubbleClipWidth: CGFloat = 0
    
    //Layout da mensagem:
    var body: some View{
        VStack(alignment: isHero ? .leading : .trailing, spacing: 6){
            //Se for IA, bolha de texto à esquerda
            HStack(alignment: .top, spacing: 10){
                if isHero{
                    
                    AvatarView()
                    
                    textBubble
                        .frame(maxWidth: 500, alignment: .leading)
                    
                   // Spacer(minLength: 0)
                } else{
                    
                    Spacer(minLength: 0)
                    
                    textBubble
                       // .padding(.trailing, 0)
                        .frame(maxWidth: 300, alignment: .trailing)
                }
            }
            .padding(.vertical, 10)
            
            if isHero && !message.suggestions.isEmpty{
                ChipsSuggestionsView(suggestions: message.suggestions, onTap: onSuggestion)
                   .padding(.leading, 36)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private var textContent: some View {
        if isHero {
            StreamingTextView(
                text: message.text,
                skipAnimation: skipAnimation,
                onNaturalWidthChanged: { newWidth in
                    guard !skipAnimation else { return }
                    withAnimation(.easeInOut(duration: 0.38).delay(0.05)) {
                        bubbleClipWidth = newWidth + 28
                    }
                },
                onTick: onStreamTick
            )
        } else {
            Text(message.text).font(.body)
        }
    }

    private var useClipAnimation: Bool {
        isHero && !skipAnimation
    }

    private var textBubble: some View {
        textContent
            .padding(.horizontal, 14)
            .padding(.top, 10)
            .padding(.bottom, 16)
            .background(isHero ? Color(.systemFill).opacity(0.55) : Color(GlobalConfiguration.primaryBlue))
            .foregroundStyle(isHero ? Color.secondary : Color.white)
            .mask(alignment: .leading) {
                if useClipAnimation {
                    RoundedRectangle(cornerRadius: GlobalConfiguration.normalCornerRadius)
                        .frame(width: bubbleClipWidth)
                } else {
                    RoundedRectangle(cornerRadius: GlobalConfiguration.normalCornerRadius)
                }
            }
    }
}

