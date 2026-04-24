//
//  MetricCard.swift
//  Challenge13
//
//  Created by Caio Mandarino on 23/04/26.
//

import SwiftUI

struct MetricCard: View {

    let label: String
    let value: String
    let caption: String?

    private enum Layout {
        static let labelFontSize: CGFloat = 12
        static let labelTracking: CGFloat = 0.48
        static let valueFontSize: CGFloat = 28
        static let captionFontSize: CGFloat = 12
        static let spacing: CGFloat = 4
        static let padding: CGFloat = 4
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Layout.spacing) {
            Text(label)
                .font(.system(size: Layout.labelFontSize, weight: .semibold))
                .tracking(Layout.labelTracking)
                .foregroundStyle(Color.secondary)
                .textCase(.uppercase)

            Text(value)
                .font(.system(size: Layout.valueFontSize, weight: .bold))
                .foregroundStyle(Color.primary)

            if let caption {
                Text(caption)
                    .font(.system(size: Layout.captionFontSize))
                    .foregroundStyle(Color.secondary)
            }
        }
        .padding(Layout.padding)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    HStack {
        MetricCard(label: "SESSÕES", value: "42", caption: "+8 vs sem. ant.")
        MetricCard(label: "HORAS", value: "38h", caption: "+3h")
    }
    .padding()
}
