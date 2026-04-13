//
//  LockScreenView.swift
//  Challenge13
//
//  Created by Caio Mandarino on 11/04/26.
//

import SwiftUI

struct LockScreenView: View {
    @ObservedObject var coordinator: MainTabCoordinator
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        VStack {
            Button("Unlock") {
                Task {
                    do {
                        try await coordinator.authentication()
                    } catch {
                        print("Auth error:", error.localizedDescription) // no caso eu logo para um alerta, isso é provável de acontecer caso o usuário tire a senha do celular, dai eu mantém o bloqueio ou não?
                    }
                }
            }

        }
        .onChange(of: scenePhase) { _ , newValue in
            if newValue == .active {
                Task {
                    do {
                        try await coordinator.authentication()
                    } catch {
                        print("Auth error:", error.localizedDescription)
                    }
                }
            }
        }
    }
}

#Preview {
    LockScreenView(
        coordinator: .init(
            databaseService: .init(context: makeMainContext()),
            authenticationService: .init(),
            screenMonitor: .shared,
            settingsStore: .shared
        )
    )
}
