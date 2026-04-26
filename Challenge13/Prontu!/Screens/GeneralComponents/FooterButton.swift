//
//  ActionButton.swift
//  Challenge13
//
//  Created by Linda Marie Ribeiro Alves Correa dos Santos on 23/04/26.
//

import SwiftUI

struct FooterButton: View {
    
    let title: String
    let isEnabled: Bool
    let action: () -> Void
    let ctaDisabledOpacity: Double = 0.35
    let ctaDisabledScale: CGFloat = 0.98
    let footerHeight: CGFloat = 55
    let footerBottomPadding: CGFloat = 32
    let ctaStateAnimationDuration: Double = 0.3
    
    var body: some View {
        
        Button(action: action) {
            
            Text(title)
                .font(.system(
                    size: GlobalConfiguration.Layout.sectionHeaderFontSize,
                    weight: .semibold
                ))
                .foregroundStyle(
                    .white.opacity(isEnabled ? 1 : ctaDisabledOpacity))
                .frame(maxWidth: .infinity)
                .frame(
                    height: footerHeight)
                .background( GlobalConfiguration.primaryBlue.opacity(isEnabled ? 1 : ctaDisabledOpacity))
                .clipShape(
                    RoundedRectangle(cornerRadius: GlobalConfiguration.normalCornerRadius))
        }
        .disabled(!isEnabled)
        .scaleEffect(isEnabled ? 1
                     : ctaDisabledScale
        )
        .animation(
            .spring(
                response: ctaStateAnimationDuration,
                dampingFraction: 0.7
            ),
            value: isEnabled
        )
        .padding(.horizontal, GlobalConfiguration.normalSpacing)
        .padding(.top, GlobalConfiguration.normalSpacing)
        .padding(
            .bottom,footerBottomPadding)
        .background(Color(.systemGroupedBackground))
    }
}
