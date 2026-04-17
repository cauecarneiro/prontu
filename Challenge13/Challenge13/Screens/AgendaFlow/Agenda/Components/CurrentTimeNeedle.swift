//
//  CurrentTimeNeedle.swift
//  Challenge13
//
//  Created by Caio Mandarino on 15/04/26.
//

import SwiftUI

struct CurrentTimeNeedle: View {
    let time: Date
    let width: CGFloat
    let leftInset: CGFloat

    var body: some View {
        Rectangle()
            .fill(GlobalConfiguration.primaryBlue)
            .frame(width: width, height: Layout.lineThickness)
            .overlay(alignment: .leading) {
                Circle()
                    .fill(GlobalConfiguration.primaryBlue)
                    .frame(width: Layout.dotSize, height: Layout.dotSize)
                    .offset(x: leftInset - Layout.dotSize / 2)
            }
            .accessibilityLabel("Agora: \(timeLabel)")
    }

    private var timeLabel: String {
        Self.timeFormatter.string(from: time)
    }

    private static let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "pt_BR")
        f.dateFormat = "HH:mm"
        return f
    }()

    private enum Layout {
        static let dotSize: CGFloat = 10
        static let lineThickness: CGFloat = 1.5
    }
}

// MARK: - Preview

#Preview("CurrentTimeNeedle") {
    CurrentTimeNeedle(time: Date(), width: 350, leftInset: 52)
        .padding(.vertical, 40)
        .background(Color(.systemBackground))
}
