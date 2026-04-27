//
//  OnBoardingPageView.swift
//  Prontu!
//
//  Created by Luciana Liebl de Freitas on 27/04/26.
//
import SwiftUI

struct OnBoardingPageView: View{
    
    let page: PageData
    let action: () -> Void
    
    var body: some View{
        
        VStack{
            
            Spacer()
            
            Image(systemName: page.image)
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 180)
                .foregroundStyle(Color(GlobalConfiguration.primaryBlue))
                .padding(.bottom, 40)
            
            Text(page.title)
                .font(.title2)
                .bold()
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Text(page.description)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .padding(.top, 12)
            
            Spacer()
            
            ContinueButton(label: "Continuar", action: action)
            }
        }
    }//end body
}

