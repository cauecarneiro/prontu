//
//  ChipsSuggestionsView.swift
//  Challenge13
//
//  Created by Luciana Liebl de Freitas on 14/04/26.
//
import SwiftUI
import SwiftData
struct ChipsSuggestionsView: View{
    
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
