//
//  ClientRow.swift
//  Challenge13
//
//  Created by Luciana Liebl de Freitas on 22/04/26.
//

import SwiftUI

struct ClientRow: View{
    let client: Client
    
    var avatarColor: Color {
        GlobalConfiguration.avatarColor(for: client.name)
    }
    
    var body: some View{
        HStack(spacing: 12){
            Circle()
                .fill(avatarColor)
                .frame(width: 50, height: 50)
                //Overlay coloca as iniciais por cima do circulo
                .overlay(
                    Text(client.initials)
                        .foregroundColor(.white)
                        .font(.custom("SFCompactRounded-Semibold", size: 24))
                )
            
            VStack(alignment: .leading){
                Text(client.name)
                    .font(.headline)
                
            }
            //Empurra o conteúdo para a esquerda
            Spacer()
        }
        .padding()
    }
}
