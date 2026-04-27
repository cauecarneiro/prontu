//
//  ConsentView.swift
//  Prontu!
//
//  Created by Luciana Liebl de Freitas on 27/04/26.
//
import SwiftUI

struct ConsentView: View{
    
    let acceptAction: () -> Void
    
    var body: some View{
        //Layout da tela de consentimento
            VStack{
                
                Spacer()
                
                Image(systemName: "doc.text.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundStyle(Color(GlobalConfiguration.primaryBlue))
                    .padding(.bottom, 32)
                
                Text("Tratamento de Dados")
                    .font(.title2)
                    .bold()
                    .padding(.bottom, 24)
                
                //Cards com os linkd
                VStack{
                    Link(destination: URL(string: "https://seuapp.com/termos")!){
                        DocRowView(icon: "doc.text", label: "Termos de Serviço")
                    }
                    
                    Divider().padding(.leading, 16)
                    
                    Link(destination: URL(string: "https://seuapp.com/privacidade")!){
                        DocRowView(icon: "lock.doc", label: "Política de Privacidade")
                    }
                }
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Spacer()
                
                ContinueButton(label: "Aceitar e Continuar", action: acceptAction)
                
                Text("Ao continuar, você concorda com os Termos de Serviço e a Política de Privacidade.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 24)
        }
    }//end body
}//end View

#Preview("Consent") {
    ConsentView {
        print("Aceitou")
    }
}
