//
//  TypingIndicatorView.swift
//  Challenge13
//
//  Created by Luciana Liebl de Freitas on 14/04/26.
//
import SwiftUI
import SwiftData


//Indicador de digitação
struct TypingIndicatorView: View{
    
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
