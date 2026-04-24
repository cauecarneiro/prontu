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
                .frame(width: 44, height: 44)
                //Overlay coloca as iniciais por cima do circulo
                .overlay(
                    Text(client.initials)
                        .foregroundColor(.white)
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
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
