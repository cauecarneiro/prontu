//
//  LockScreenView.swift
//  Challenge13
//
//  Created by Caio Mandarino on 11/04/26.
//

import SwiftUI

struct LockScreenView: View {
    @ObservedObject var coordinator: MainTabCoordinator
    
    var body: some View {
        VStack {
            Button("Unlock") {
                Task {
                    do {
                        let result = try await coordinator.authentication()
                        if result {
                            coordinator.unlockApp()
                        }
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
            authenticationService: .init()
        )
    )
}
