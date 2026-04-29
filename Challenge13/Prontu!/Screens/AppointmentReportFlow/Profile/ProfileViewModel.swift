//
//  ProfileViewModel.swift
//  Challenge13
//
//  Created by Codex on 26/04/26.
//

import Combine
import Foundation
import LocalAuthentication

final class ProfileViewModel: ObservableObject {

    var isAuthenticated: Bool {
        get {
            SettingsStore.shared.isAuthenticationEnabled
        }
        set {
            let validator = AppLockValidatorService()
            guard validator.validate() == .available else { return }

            SettingsStore.shared.setAuthenticationEnabled(newValue)

            if newValue {
                // Dispara o pedido de permissão nativo do Face ID / Touch ID
                Task {
                    let context = LAContext()
                    _ = try? await context.evaluatePolicy(
                        .deviceOwnerAuthenticationWithBiometrics,
                        localizedReason: "Ative o Face ID para proteger o acesso ao Prontu!"
                    )
                }
            }
        }
    }

    weak private var coordinator: (any ProfileCoordinatorProtocol)?

    init(coordinator: (any ProfileCoordinatorProtocol)?) {
        self.coordinator = coordinator
    }

}
