//
//  Untitled.swift
//  Challenge13
//
//  Created by Linda Marie Ribeiro Alves Correa dos Santos on 22/04/26.
//

import SwiftUI

struct AddEquipament: View {
    
    var title: String = "Recursos da Sessão"
    var buttonString: String = "Gerar Sugestão"
    
    var body: some View {
        
        
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            Button(action: {
                print("Adicionar recurso clicado")
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text(buttonString)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.blue)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue.opacity(0.6), style: StrokeStyle(lineWidth: 1, dash: [5]))
                )
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .padding()
    }
}

#Preview {
    AddEquipament()
}
