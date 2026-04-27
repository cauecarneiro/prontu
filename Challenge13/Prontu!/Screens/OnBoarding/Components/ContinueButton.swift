//
//  ContinueButton.swift
//  Prontu!
//
//  Created by Luciana Liebl de Freitas on 27/04/26.
//
import SwiftUI

struct ContinueButton: View{
    
    let label: String
    let action: () -> Void
    
    var body: some View{
            Button(action: action){
                Text(label)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
            }
            .background(Color(GlobalConfiguration.primaryBlue))
            .clipShape(Capsule())
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
    }//end body
}//end View
