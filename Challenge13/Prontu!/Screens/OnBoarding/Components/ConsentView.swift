//
//  ConsentView.swift
//  Prontu!
//
//  Created by Luciana Liebl de Freitas on 27/04/26.
//
import SwiftUI

struct ConsentView: View{

    let acceptAction: () -> Void

    @State private var showTermsSheet = false
    @State private var showPrivacySheet = false

    var body: some View{
        VStack{
            Spacer()

            Image("Documento")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .padding(.bottom, 32)

            Text("Tratamento de Dados")
                .font(.title2)
                .bold()
                .padding(.bottom, 24)

            VStack(spacing: 0){
                Button {
                    showTermsSheet = true
                } label: {
                    DocRowView(icon: "doc.text", label: "Termos de Serviço")
                }
                .foregroundStyle(.primary)

                Divider().padding(.leading, 16)

                Button {
                    showPrivacySheet = true
                } label: {
                    DocRowView(icon: "lock.doc", label: "Política de Privacidade")
                }
                .foregroundStyle(.primary)
            }
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 16)

            Spacer()

            ContinueButton(label: "Aceitar e Continuar", action: acceptAction)

            Text("Ao clicar em \"Aceitar e Continuar\", você concorda com os Termos de Serviço e a Política de Privacidade.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .padding(.bottom, 24)
        }
        .sheet(isPresented: $showTermsSheet) {
            Color(.systemGroupedBackground).ignoresSafeArea()
        }
        .sheet(isPresented: $showPrivacySheet) {
            Color(.systemGroupedBackground).ignoresSafeArea()
        }
    }
}

#Preview("Consent") {
    ConsentView {
        print("Aceitou")
    }
}
