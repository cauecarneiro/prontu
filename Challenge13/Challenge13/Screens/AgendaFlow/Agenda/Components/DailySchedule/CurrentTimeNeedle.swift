//
//  CurrentTimeNeedle.swift
//  Challenge13
//
//  Created by Caio Mandarino on 15/04/26.
//

import SwiftUI

struct CurrentTimeNeedle: View {
    let leftInset: CGFloat
    let width: CGFloat

    var body: some View {
        Rectangle()
            .fill(GlobalConfiguration.primaryBlue)
            .frame(maxWidth: .infinity, maxHeight: Layout.lineThickness)
            .overlay(alignment: .leading) {
                Circle()
                    .fill(GlobalConfiguration.primaryBlue)
                    .frame(width: width, height: width)
                    .offset(x: leftInset)
            }
    }

    private enum Layout {
        static let lineThickness: CGFloat = 1.5
    }
}

// MARK: - Preview

#Preview("CurrentTimeNeedle") {
    CurrentTimeNeedle(leftInset: 52, width: 10)
        .padding(.vertical, 40)
        .background(Color(.systemBackground))
}
