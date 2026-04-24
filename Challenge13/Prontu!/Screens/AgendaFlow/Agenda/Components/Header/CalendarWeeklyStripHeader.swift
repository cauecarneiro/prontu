//
//  CalendarWeeklyStripHeader.swift
//  Challenge13
//
//  Created by Caio Mandarino on 15/04/26.
//

import SwiftUI

struct CalendarWeeklyStripHeader: View {
    let title: String
    let onPrevious: () -> Void
    let onNext: () -> Void

    var body: some View {
        HStack(alignment: .center, spacing: Layout.headerSpacing) {
            Text(title)
                .font(.title.weight(.bold))
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(Layout.titleScaleFactor)

            Spacer(minLength: .zero)

            HStack(spacing: .zero) {
                navButton(systemName: "chevron.left", label: "Semana anterior", action: onPrevious)
                navButton(systemName: "chevron.right", label: "Próxima semana", action: onNext)
            }
        }
        .padding(.horizontal, GlobalConfiguration.normalSpacing)
    }

    private func navButton(
        systemName: String,
        label: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: Layout.chevronSize, weight: .semibold))
                .frame(width: Layout.tapTargetSize, height: Layout.tapTargetSize)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .foregroundStyle(GlobalConfiguration.primaryBlue)
        .accessibilityLabel(label)
    }

    private enum Layout {
        static let chevronSize: CGFloat = 26
        static let tapTargetSize: CGFloat = 44
        static let headerSpacing: CGFloat = 8
        static let titleScaleFactor: CGFloat = 0.65
    }
}

#Preview {
    CalendarWeeklyStripHeader(
        title: "Hoje, 15 de Abril",
        onPrevious: {},
        onNext: {}
    )
    .padding(.vertical)
}
