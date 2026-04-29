//
//  PreferencesView.swift
//  Prontu!
//

import SwiftUI

struct PreferencesView: View {

    @State private var isFaceIDEnabled: Bool
    @State private var showDisableAlert = false
    @State private var showTermsSheet = false
    @State private var showPrivacySheet = false

    private let settingsStore = SettingsStore.shared

    init() {
        _isFaceIDEnabled = State(initialValue: SettingsStore.shared.isAuthenticationEnabled)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {

                // Card Face ID
                HStack {
                    Text("Face ID")
                        .font(.body)
                    Spacer()
                    Toggle("", isOn: $isFaceIDEnabled)
                        .labelsHidden()
                        .tint(Color(GlobalConfiguration.primaryBlue))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                // Card documentos
                VStack(spacing: 0) {
                    Button {
                        showTermsSheet = true
                    } label: {
                        DocRowView(icon: "doc.text", label: "Termos de Serviço")
                    }
                    .foregroundStyle(.primary)
                    .buttonStyle(.plain)

                    Divider().padding(.leading, 16)

                    Button {
                        showPrivacySheet = true
                    } label: {
                        DocRowView(icon: "lock.doc", label: "Política de Privacidade")
                    }
                    .foregroundStyle(.primary)
                    .buttonStyle(.plain)
                }
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(16)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle("Preferências")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: isFaceIDEnabled) { newValue in
            if !newValue {
                showDisableAlert = true
            } else {
                settingsStore.setAuthenticationEnabled(true)
            }
        }
        .alert("Desativar biometria?", isPresented: $showDisableAlert) {
            Button("Manter biometria", role: .cancel) {
                isFaceIDEnabled = true
            }
            Button("Desativar assim mesmo", role: .destructive) {
                settingsStore.setAuthenticationEnabled(false)
            }
        } message: {
            Text("A autenticação biométrica ajuda a proteger o acesso ao app neste dispositivo. Ao desativá-lo, o acesso às suas informações ficará menos protegido.")
        }
        .sheet(isPresented: $showTermsSheet) {
            TermsOfUseView()
                .padding(4)
        }
        .sheet(isPresented: $showPrivacySheet) {
            PrivacyPolicyView()
                .padding(4)
        }
    }
}

#Preview {
    NavigationStack {
        PreferencesView()
    }
}
