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
    @State var error: String? = nil

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()

            VStack(spacing: 20) {
                Image(systemName: "lock.fill")
                    .font(.system(size: 56, weight: .medium))
                    .foregroundStyle(GlobalConfiguration.primaryBlue)
                    .padding(.bottom, 4)

                Text("Prontu! bloqueado")
                    .font(.title.bold())
                    .foregroundStyle(.primary)

                Button {
                    unlock()
                } label: {
                    Text("Desbloquear com Face ID")
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 16)
                        .background(GlobalConfiguration.primaryBlue)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
                .padding(.top, 4)
            }
        }
        .onChange(of: scenePhase) { _, newValue in
            if newValue == .active { unlock() }
        }
        .alert(error ?? "", isPresented: Binding(value: $error)) {
            Button("OK") { }
        }
    }

    private func unlock() {
        Task {
            do {
                try await coordinator.authentication()
            } catch {
                self.error = error.localizedDescription
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
