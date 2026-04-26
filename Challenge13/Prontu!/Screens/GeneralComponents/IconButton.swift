//
//  IconButton.swift
//  Challenge13
//
//  Created by Linda Marie Ribeiro Alves Correa dos Santos on 22/04/26.
//

import SwiftUI

let secondaryButtonOpacity: Double = 0.55

func iconButton(systemName: String,
                action: @escaping () -> Void) -> some View {

    Button(action: action, label: {
        Image(systemName: systemName)
            .font(.system(size: GlobalConfiguration.Layout.sectionHeaderFontSize,
                          weight: .semibold))
            .foregroundStyle(.primary)
            .frame(width: GlobalConfiguration.Layout.iconButtonSize,
                   height: GlobalConfiguration.Layout.iconButtonSize)
            .background(
                Color(.systemFill)
                    .opacity(secondaryButtonOpacity)
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: GlobalConfiguration.normalCornerRadius
                )
            )
    })
}
