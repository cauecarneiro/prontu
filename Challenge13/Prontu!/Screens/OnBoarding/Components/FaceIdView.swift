//
//  FaceIdView.swift
//  Prontu!
//
//  Created by Linda Marie Ribeiro Alves Correa dos Santos on 27/04/26.
//

import SwiftUI
import LocalAuthentication

struct FaceIdView: View {

    @ObservedObject var viewModel: ProfileViewModel

    // MARK: - Biometria
    
    private var biometricType: LABiometryType {
        let context = LAContext()
        context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        return context.biometryType
    }
    
    private var biometricName: String {
        switch biometricType {
        case .faceID: return "Face ID"
        case .touchID: return "Touch ID"
        default: return "Biometria"
        }
    }
    
    private var biometricIcon: String {
        switch biometricType {
        case .faceID: return "faceid"
        case .touchID: return "touchid"
        default: return "lock"
        }
    }

    var body: some View {
        VStack {
            
            Spacer()
            
            // Ícone
            Image(systemName: biometricIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundStyle(Color(GlobalConfiguration.primaryBlue))
                .padding(.bottom, 24)
            
            // Título
            Text("Privacidade e Segurança")
                .font(.title2)
                .bold()
                .padding(.bottom, 8)
            
            // Descrição
            Text("Gerencie a autenticação biométrica do seu dispositivo.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .padding(.bottom, 24)
            
            // Toggle (ligado ao ViewModel)
            HStack {
                Text(biometricName)
                Spacer()
                
                Toggle("", isOn: Binding(
                    get: { viewModel.isAuthenticated },
                    set: { viewModel.isAuthenticated = $0 }
                ))
                .labelsHidden()
                .disabled(biometricType == .none)
            }
            .padding()
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 24)
            
            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        FaceIdView(viewModel: .init(coordinator: nil))
    }
}
