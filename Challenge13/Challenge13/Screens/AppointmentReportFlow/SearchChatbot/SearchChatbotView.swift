//
//  SearchChatbotView.swift
//  Challenge13
//
//  Created by Caio Mandarino on 01/04/26.
//
import SwiftUI

struct SearchChatbotView: View {
    
    @ObservedObject var viewModel: SearchChatbotViewModel
    
    private enum Layout {
        static let topBarHeight: CGFloat = 141
        static let topBarHorizontalPadding: CGFloat = 24
        static let iconButtonSize: CGFloat = 44
        static let inputRowHeight: CGFloat = 56
        static let textAreaHeight: CGFloat = 173
        static let footerHeight: CGFloat = 55
        static let footerBottomPadding: CGFloat = 32
        static let sectionHeaderFontSize: CGFloat = 16
        static let importContactFontSize: CGFloat = 14
        static let contactCardHorizontalPadding: CGFloat = 20
        static let contactCardVerticalPadding: CGFloat = 4
        static let textAreaHorizontalPadding: CGFloat = 18
        static let textAreaVerticalPadding: CGFloat = 16
        static let animationDuration: Double = 0.25
        static let entryScale: CGFloat = 0.95
        static let sectionsSpacing: CGFloat = 24
        static let sectionSpacing: CGFloat = 8
        static let textAreaIconSpacing: CGFloat = 4
        static let secondaryButtonOpacity: Double = 0.55
        static let ctaDisabledOpacity: Double = 0.35
        static let ctaDisabledScale: CGFloat = 0.98
        static let ctaStateAnimationDuration: Double = 0.3
    }
    
    //MARK: Layout vertical
    var body: some View {
        VStack(spacing: .zero){
            
            topBar
            
            VStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.messages) { message in
                                MessageBubbleView(message: message){ suggestion in
                                    viewModel.sendSuggestion(suggestion)
                                }
                                .id(message.id)
                                
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
                        .scrollDismissesKeyboard(.interactively)
                        .onChange(of: viewModel.messages.count) { _, _ in
                            rollDown(proxy: proxy)
                        }
                        .onChange(of: viewModel.loading) { _, loading in
                            if loading {
                                withAnimation(.easeOut(duration: 0.25)){
                                    proxy.scrollTo("typing", anchor: .bottom)
                                }
                            }
                        }
                    }
                }
                
                inputBar
            }
        }
    }
    
    private var topBar: some View {
        HStack(alignment: .center) {
            iconButton(systemName: "xmark") {
               // viewModel.dismiss()
            }
            
            Spacer()
            
            HStack(spacing: 8){
                Image(systemName: "sparkle")
                    .foregroundColor(GlobalConfiguration.primaryBlue)
                
                Text("Assistente")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color.secondary)
            }
            
            Spacer()
            
            Color.clear
                .frame(width: Layout.iconButtonSize, height: Layout.iconButtonSize)
        }
        .padding(.horizontal, 24)
        //.frame(height: 141)
    }
    
    
    private func iconButton(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: Layout.sectionHeaderFontSize, weight: .semibold))
                .foregroundStyle(.black)
                .frame(width: Layout.iconButtonSize, height: Layout.iconButtonSize)
                .background(Color(.systemFill).opacity(Layout.secondaryButtonOpacity))
                .clipShape(RoundedRectangle(cornerRadius: GlobalConfiguration.normalCornerRadius))
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
                viewModel.sendUserMessage(viewModel.typedText)
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
    SearchChatbotView(
        viewModel: .init(
            engine: .init(
                provider: DatabaseService(context: makeMainContext()),
                classifier: .init()
            )
        )
    )
    
}

//#Preview {
//    let coordinator = makeRegisterFlowCoordinator()
//    CreateClientView(viewModel: .init(
//        databaseService: makeRegisterFlowDatabaseService(),
//        coordinator: coordinator
//    ))
//}
