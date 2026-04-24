//
//  Untitled.swift
//  Challenge13
//
//  Created by Linda Marie Ribeiro Alves Correa dos Santos on 22/04/26.
//

import SwiftUI

struct PickerClientButton: View {
    
    var client: Client?
    var action: () -> Void
    var title : String = "Selecionar cliente"
    
    var body: some View {
        Button(action: action) {
            
                if let client = client {
                    ClientRow(client: client)
//                        .padding(.horizontal)
//                        .background {
//                            RoundedRectangle(cornerRadius: GlobalConfiguration.normalCornerRadius)
//                                .foregroundStyle(.white)
//                        }
                    
                }else{
                    
                    HStack{
                        Image(systemName: "person.circle")
                            .foregroundColor(.gray)
                        Text(title)
                            .foregroundColor(.gray)
                            .font(.system(size: 16, weight: .semibold))
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(.white)
                    .cornerRadius(16)

                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.blue, lineWidth: 2)
            )
    }
}

