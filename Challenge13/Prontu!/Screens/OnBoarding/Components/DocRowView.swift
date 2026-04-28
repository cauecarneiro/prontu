//
//  DocRowView.swift
//  Prontu!
//
//  Created by Luciana Liebl de Freitas on 27/04/26.
//
import SwiftUI

struct DocRowView: View{
    
    let icon: String
    let label: String
    
    var body: some View{
        HStack{
            Image(systemName: icon)
                .foregroundStyle(.secondary)
            
            Text(label)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
                .font(.footnote)
            
        }
        .padding()
    }//end body
}//end View
