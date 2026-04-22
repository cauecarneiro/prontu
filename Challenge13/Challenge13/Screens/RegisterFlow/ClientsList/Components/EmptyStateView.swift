//
//  EmptyStateView.swift
//  Challenge13
//
//  Created by Luciana Liebl de Freitas on 22/04/26.
//

import SwiftUI

struct EmptyStateView: View{
    
    var body: some View{
        VStack(spacing: 12){
            Image(systemName: "magnifyingglass")
                .font(.system(size: 40))
                .foregroundColor(.gray)
            
            Text("Nenhum cliente encontrado")
                .font(.headline)
                .foregroundColor(.black)
            
            Text("Tente outro nome ou cadastre um novo cliente pelo botão '+' no canto inferior.")
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .foregroundColor(.gray)
                .padding(.horizontal, 32)
                
        }
        .padding()
    }
}
