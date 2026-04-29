//
//  AppLockValidatorService.swift
//  Challenge13
//
//  Created by Caio Mandarino on 09/04/26.
//

import LocalAuthentication

struct AppLockValidatorService {
    
    func validate() -> AppLockAvailability {
        let context = LAContext()
        var error: NSError?

        let canEvaluate = context.canEvaluatePolicy(
            .deviceOwnerAuthentication,
            error: &error
        )

        guard canEvaluate else {
            if let laError = error as? LAError {
                switch laError.code {
                case .passcodeNotSet:
                    return .unavailable(reason: "O aparelho está sem senha configurada.")
                case .biometryNotEnrolled:
                    return .unavailable(reason: "Não há Face ID/Touch ID cadastrado.")
                case .biometryNotAvailable:
                    return .unavailable(reason: "A biometria não está disponível neste aparelho.")
                default:
                    return .unavailable(reason: "Autenticação local indisponível.")
                }
            }

            return .unavailable(reason: "Autenticação local indisponível.")
        }

        return .available
    }

    func authenticate() async throws -> Bool {
        let context = LAContext()
        return try await context.evaluatePolicy(
            .deviceOwnerAuthentication,
            localizedReason: "Autentique-se para entrar no app."
        )
    }
}
