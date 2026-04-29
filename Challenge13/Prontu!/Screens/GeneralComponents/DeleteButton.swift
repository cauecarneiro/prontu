//
//  DeleteButton.swift
//  Prontu!
//
//  Created by Caio Mandarino on 26/04/26.
//

import SwiftUI

struct DeleteButton: View {
    let action: () -> Void
    
    private enum TextValue {
        static let deleteButtonTitle = "Apagar compromisso"
    }
    
    var body: some View {
        Button(action: action) {
            Text(TextValue.deleteButtonTitle)
                .font(.system(
                    size: GlobalConfiguration.Layout.sectionHeaderFontSize,
                    weight: .semibold
                ))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: GlobalConfiguration.Layout.inputRowHeight)
                .background(GlobalConfiguration.destructiveRed)
                .clipShape(
                    RoundedRectangle(cornerRadius: GlobalConfiguration.normalCornerRadius)
                )
        }
        .padding(.horizontal, GlobalConfiguration.normalSpacing)
    }
}
