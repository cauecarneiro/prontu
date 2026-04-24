//
//  AnchorTimeMark.swift
//  Challenge13
//
//  Created by Caio Mandarino on 15/04/26.
//

import SwiftUI

struct AnchorTimeMark: View {
    let time: Date

    var body: some View {
        HStack(spacing: Layout.labelPadding) {
            Text(timeLabel)
                .font(Layout.labelFont)
                .foregroundStyle(.secondary)

            Rectangle()
                .fill(Color.secondary.opacity(Layout.lineOpacity))
                .frame(height: Layout.lineThickness)
        }
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
        static let labelPadding: CGFloat = 6
        static let lineOpacity: Double = 0.25
        static let lineThickness: CGFloat = 0.5
        static let labelFont: Font = .caption2
    }
}

// MARK: - Preview

#Preview("AnchorTimeMark") {
    VStack(spacing: 60) {
        AnchorTimeMark(time: Date())
        AnchorTimeMark(time: Date().addingTimeInterval(3600))
        AnchorTimeMark(time: Date().addingTimeInterval(7200))
    }
    .padding()
    .background(Color(.systemBackground))
}
