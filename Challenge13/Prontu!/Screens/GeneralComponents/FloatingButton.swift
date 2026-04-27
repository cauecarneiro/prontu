//
//  FloatingButton.swift
//  Challenge13
//
//  Created by Caio Mandarino on 20/04/26.
//

import SwiftUI

struct FloatingButton: View {
    let systemImageName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: systemImageName)
                .font(.system(size: 30, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: 32, maxHeight: 32)
                .padding(12)
                .background {
                    Circle()
                        .fill(GlobalConfiguration.primaryBlue)
                }
        }
        .buttonStyle(FloatingButtonStyle())
    }
}

#Preview {
    VStack {
        FloatingButton(systemImageName: "calendar") {}
        
        FloatingButton(systemImageName: "calendar.badge.plus") {}
    }
}

struct FloatingButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.5 : 1)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}
