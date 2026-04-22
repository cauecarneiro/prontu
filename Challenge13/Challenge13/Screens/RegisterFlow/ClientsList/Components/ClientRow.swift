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
        let colors: [Color] = [.blue, .green, .orange, .purple, .pink, .teal]
        //hashValue transforma o nome em um número sempre igual para o mesmo nome
        //abs = valor absoluto
        //% = módulo, pega o resto da divisão
        //color.count = 6, então sempre divide o hash por 6 e o resultado será sempre entre 0 até 5
        let index = abs(client.name.hashValue) % colors.count
        return colors[index]
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
                        .bold()
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
