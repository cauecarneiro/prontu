//
//  SettingsStore.swift
//  Challenge13
//
//  Created by Codex on 11/04/26.
//

import Foundation

extension Notification.Name {
    static let authenticationSettingDidChange = Notification.Name("authenticationSettingDidChange")
}

enum SettingsStoreUserInfoKey {
    static let isAuthenticationEnabled = "isAuthenticationEnabled"
}

final class SettingsStore {
    static let shared = SettingsStore()
    
    private let userDefaults: UserDefaults
    private let notificationCenter: NotificationCenter
    
    init(
        userDefaults: UserDefaults = .standard,
        notificationCenter: NotificationCenter = .default
    ) {
        self.userDefaults = userDefaults
        self.notificationCenter = notificationCenter
    }
    
    var isAuthenticationEnabled: Bool {
        userDefaults.bool(forKey: UserDefaultsKeys.userEnableAuthentication)
    }
    
    func setAuthenticationEnabled(_ isEnabled: Bool) {
        let previousValue = isAuthenticationEnabled
        guard previousValue != isEnabled else { return }
        
        userDefaults.set(isEnabled, forKey: UserDefaultsKeys.userEnableAuthentication)
        notificationCenter.post(
            name: .authenticationSettingDidChange,
            object: self,
            userInfo: [SettingsStoreUserInfoKey.isAuthenticationEnabled: isEnabled]
        )
    }
}
