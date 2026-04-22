//
//  HeaderClientsView.swift
//  Challenge13
//
//  Created by Luciana Liebl de Freitas on 22/04/26.
//
import SwiftUI

struct HeaderClientsView: View{
    
    @Binding var search: String
    
    var body: some View{
        VStack(alignment: .leading, spacing: 16){
            
            Text("Clientes")
                .font(.largeTitle)
                .bold()
            
            HStack{
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("Buscar cliente", text: $search) //biding liga UI com variável
            }
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(100)
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .background(Color(.systemGray5))
        .padding()
    }//end body
}//end View
