//
//  SearchChatbotView.swift
//  Challenge13
//
//  Created by Caio Mandarino on 01/04/26.
//
import SwiftData
import SwiftUI

struct SearchChatbotView: View {
    
    @Query(sort: \Appointment.startDate) private var appointments: [Appointment]
    @State private var viewModel = SearchChatbotViewModel()
    
    //MARK: Layout vertical
    var body: some View {
        VStack(spacing: 0){
            listMessages
        }
        .navigationTitle("Hero")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    //MARK: Lista de mensagens
    private var listMessages: some View {
        //Permite rolar o chat
        ScrollViewReader{ proxy in
            ScrollView{
                LazyVStack(spacing: 12){
                    //Percorre todas as mensagens do chat
                    ForEach(viewModel.messages){
                        message in
                        //cada mensagem vira uma "bolha"
                        MessageBubbleView(message: message){
                            suggestion in viewModel.selectSuggestion(suggestion, appointment: appointments)
                        }
                        .id(message.id)
                        
                        //Indicar que a IA está pensando
                        if viewModel.loading{
                            TypingIndicatorView()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 16)
                                .id("typing")
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 20)
                }
                //Abaixa o teclado no scroll
                .scrollDismissesKeyboard(.interactively)
                //Sempre que um nova mensagem chega, rola o chat para baixo automaticamente
                .onChange(of: viewModel.messages.count){_, _ in
                    rollDown(proxy: proxy)
                }
                //quando o Foundation começar a responder mostra animação de digitação
                .onChange(of: viewModel.loading){ _, loading in
                    if loading{
                        //faz acontecer a animação
                        withAnimation(.easeOut(duration: 0.25)){
                            //deixa o "typing visivel na parte de baixo da tela"
                            proxy.scrollTo("typing", anchor: .bottom)
                        }
                    }
                }
            }
        }
    }
    
    //MARK: Barra de entrada
    private var inputBar: some View{
        HStack(alignment: .bottom, spacing: 10){
            TextField("Mensagem...", text: $viewModel.typedText, axis: .vertical)
                .padding(.horizontal, 14)
                .padding(.vertical, 9)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                .lineLimit(1...4)
                .font(.body)
            
            Button{
                viewModel.sendFreeMessage(appointments: appointments)
            }label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 34))
                    .foregroundStyle(viewModel.canSend ? Color.accentColor : Color(.systemGray3))
            }
            .disabled(!viewModel.canSend)
            .animation(.easeInOut(duration: 0.15), value: viewModel.canSend)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
    }
    
    //MARK: Helpers
    private func rollDown(proxy: ScrollViewProxy){
        //Rola até a última mensagem
        guard let id = viewModel.messages.last?.id else {return}
        withAnimation(.easeOut(duration: 0.25)){
            proxy.scrollTo(id, anchor: .bottom)
        }
    }
}

    //Bolha de mensagem
    private struct MessageBubbleView: View{
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

private struct ChipsSuggestionsView: View{
    
    let suggestions: [HeroSuggestion]
    let onTap: (HeroSuggestion) -> Void
    
    var body: some View{
        //Scroll horizontal das sugestões
        ScrollView(.horizontal, showsIndicators: false){
            //Cada sugestão vira um botão
            HStack(spacing: 8){
                ForEach(suggestions){ suggestion in
                    Button(suggestion.title){
                        onTap(suggestion)
                    }
                    .font(.subheadline)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 7)
                    .background(Color.accentColor.opacity(0.08))
                    .foregroundStyle(Color.accentColor)
                    .clipShape(Capsule())
                    .overlay(Capsule().strokeBorder(Color.accentColor.opacity(0.25), lineWidth: 1))
                }
            }
            .padding(.vertical, 2)
        }
    }
}

//Indicador de digitação
private struct TypingIndicatorView: View{
    
    @State private var animating = false
    
    var body: some View{
        HStack(spacing: 5){
            ForEach(0..<3, id: \.self){
                index in
                Circle()
                    .fill(Color(.tertiaryLabel))
                    .frame(width: 7, height: 7)
                    .scaleEffect(animating ? 1.2 : 0.7)
                    .opacity(animating ? 1.0 : 0.3)
                    .animation(
                        .easeInOut(duration: 0.45)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.15),
                        value: animating
                    )
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .onAppear { animating = true }
        .onDisappear { animating = false }
    }
}
