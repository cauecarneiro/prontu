//
//  GlobalConfiguration.swift
//  Challenge13
//
//  Created by Caio Mandarino on 14/04/26.
//

import Foundation
import SwiftUI

enum GlobalConfiguration {
    // MARK: - Colors
    static var primaryGreen: Color { Color(.primaryGreen) }
    static var primaryBlue: Color { Color(.primaryBlue) }

    // MARK: - Spacing & Radius
    static var normalSpacing: CGFloat { 16 }
    static var normalCornerRadius: CGFloat { 22 }

    // MARK: - Avatar Colors
    static var avatarTeal:   Color { Color(.avatarTeal) }
    static var avatarPurple: Color { Color(.avatarPurple) }
    static var avatarAmber:  Color { Color(.avatarAmber) }
    static var avatarPink:   Color { Color(.avatarPink) }
    static var avatarGreen:  Color { Color(.avatarGreen) }
    static var avatarBlue:   Color { Color(.avatarBlue) }

    private static var avatarPalette: [Color] {
        [avatarTeal, avatarPurple, avatarAmber, avatarPink, avatarGreen, avatarBlue]
    }

    static func avatarColor(for name: String) -> Color {
        let index = Int(name.unicodeScalars.first?.value ?? 0) % avatarPalette.count
        return avatarPalette[index]
    }
  
    static var dataFileName: String { "dados" }
    static var fileExtension: String { "json" }
}
