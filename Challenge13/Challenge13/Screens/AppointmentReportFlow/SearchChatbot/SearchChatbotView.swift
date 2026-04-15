//
//  SearchChatbotView.swift
//  Challenge13
//
//  Created by Caio Mandarino on 01/04/26.
//
import SwiftData
import SwiftUI

struct SearchChatbotView: View {
    
    @ObservedObject var viewModel: SearchChatbotViewModel
    
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
        VStack {
            ScrollViewReader{ proxy in
                ScrollView{
                    LazyVStack(spacing: 12){
                        //Percorre todas as mensagens do chat
                        ForEach(viewModel.messages){
                            message in
                            //cada mensagem vira uma "bolha"
                            MessageBubbleView(message: message){
                                suggestion in viewModel.selectSuggestion(suggestion, appointment: viewModel.appointments)
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
            
            inputBar
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
                viewModel.sendFreeMessage(appointments: viewModel.appointments)
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

#Preview {
    SearchChatbotView(viewModel: .init(appointments: []))
    
}


