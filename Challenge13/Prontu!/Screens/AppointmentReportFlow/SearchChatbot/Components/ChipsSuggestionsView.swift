//
//  ChipsSuggestionsView.swift
//  Challenge13
//
//  Created by Luciana Liebl de Freitas on 14/04/26.
//
import SwiftUI
import SwiftData

struct ChipsSuggestionsView: View{
    
    //Conteúdo dos botões/array de sugestões
    let suggestions: [HeroSuggestion]
    
    //Closure/funçao que a View recebe um HeroSuggestion e serve para indicar em qual sugestão clicaram
    let onTap: (HeroSuggestion) -> Void
    
    var body: some View{
        
        //Grid das linhas
        //Lazy: só renderiza o que aparece
        FlowLayout(spacing: 8, lineSpacing: 8){
            //Percorre o array e para cada item do array cria uma View
            ForEach(suggestions){ suggestion in
                //Cria um botão
                Button(suggestion.title){
                    //Quando clicar no botão chama a funçao passando a sugestão clicada
                    onTap(suggestion)
                }
                .font(.subheadline)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .foregroundColor(GlobalConfiguration.primaryBlue)
                .background(Color.clear)
                //Formato oval para o botão
                .clipShape(Capsule())
                .overlay(
                    Capsule().strokeBorder(Color((GlobalConfiguration.primaryBlue)), lineWidth: 1.2)
                )
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 2)
    }//end body
}//end View
