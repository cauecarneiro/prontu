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
        VStack {
            Button("Unlock") {
                Task {
                    do {
                        try await coordinator.authentication()
                    } catch {
                        self.error = error.localizedDescription
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
                        self.error = error.localizedDescription
                    }
                }
            }
        }
        .alert(error ?? "", isPresented: Binding(value: $error) ) {
            Button("OK") {
                
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
