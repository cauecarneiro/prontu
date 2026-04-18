//
//  ScheduleCard.swift
//  Challenge13
//
//  Created by Caio Mandarino on 15/04/26.
//

import SwiftUI

enum ScheduleCardState {
    case standard
    case active
    case past
}

struct ScheduleCard: View {
    let appointment: Appointment
    let state: ScheduleCardState
    let navigateTo: (Appointment) -> Void
    
    private var isBlocked: Bool {
        appointment.status == .blocked
    }

    private var style: ScheduleCardStyle {
        if isBlocked {
            return .blocked
        }

        switch state {
        case .standard:
            return .standard
        case .active:
            return .active
        case .past:
            return .past
        }
    }

    var body: some View {
        content
            .padding(.horizontal, Layout.horizontalPadding)
            .padding(.vertical, Layout.verticalPadding)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background {
                RoundedRectangle(cornerRadius: GlobalConfiguration.normalCornerRadius)
                    .fill(style.backgroundColor)
            }
            .overlay {
                RoundedRectangle(cornerRadius: GlobalConfiguration.normalCornerRadius)
                    .stroke(style.borderColor, lineWidth: Layout.borderWidth)
            }
            .opacity(style.opacity)
            .onTapGesture {
                navigateTo(appointment)
            }
    }

    @ViewBuilder
    private var content: some View {
        if isBlocked {
            blockedContent
        } else {
            regularContent
        }
    }

    private var regularContent: some View {
        VStack(alignment: .leading, spacing: Layout.contentSpacing) {
            headerRow(foreground: GlobalConfiguration.primaryBlue)

            if let clientName = appointment.client?.name {
                Text(clientName)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
            }

            Text(statusLabel)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }

    private var blockedContent: some View {
        HStack(spacing: Layout.contentSpacing) {
            Image(systemName: "lock.fill")
                .font(.caption2)
                .foregroundStyle(.secondary)

            headerRow(foreground: .secondary)
        }
    }

    private func headerRow(foreground: Color) -> some View {
        HStack(spacing: Layout.contentSpacing) {
            Text(startTimeLabel)
                .font(.caption.weight(.semibold))
                .foregroundStyle(foreground)

            Text(durationLabel)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var startTimeLabel: String {
        Self.timeFormatter.string(from: appointment.startDate)
    }

    private var durationLabel: String {
        Self.formatDuration(from: appointment.startDate, to: appointment.endDate)
    }

    private var statusLabel: String {
        switch appointment.status {
        case .scheduled:
            return "Agendado"
        case .confirmed:
            return "Confirmado"
        case .finished:
            return "Finalizado"
        case .cancelled:
            return "Cancelado"
        case .blocked:
            return "Bloqueio"
        }
    }

    private static func formatDuration(from start: Date, to end: Date) -> String {
        let minutes = max(Int(end.timeIntervalSince(start) / 60), 0)

        switch minutes {
        case 0:
            return "0min"
        case 1..<60:
            return "\(minutes)min"
        default:
            let hours = minutes / 60
            let remainder = minutes % 60
            return remainder == 0 ? "\(hours)h" : "\(hours)h \(remainder)min"
        }
    }

    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    private struct ScheduleCardStyle {
        let backgroundColor: Color
        let borderColor: Color
        let opacity: Double

        static let standard = ScheduleCardStyle(
            backgroundColor: GlobalConfiguration.primaryBlue.opacity(Layout.standardBackgroundOpacity),
            borderColor: GlobalConfiguration.primaryBlue.opacity(Layout.standardBorderOpacity),
            opacity: 1
        )

        static let active = ScheduleCardStyle(
            backgroundColor: GlobalConfiguration.primaryBlue.opacity(Layout.activeBackgroundOpacity),
            borderColor: GlobalConfiguration.primaryBlue,
            opacity: 1
        )

        static let past = ScheduleCardStyle(
            backgroundColor: GlobalConfiguration.primaryBlue.opacity(Layout.standardBackgroundOpacity),
            borderColor: GlobalConfiguration.primaryBlue.opacity(Layout.standardBorderOpacity),
            opacity: Layout.pastOpacity
        )

        static let blocked = ScheduleCardStyle(
            backgroundColor: Color.secondary.opacity(Layout.blockedBackgroundOpacity),
            borderColor: Color.secondary.opacity(Layout.blockedBorderOpacity),
            opacity: 1
        )
    }

    private enum Layout {
        static let horizontalPadding: CGFloat = 8
        static let verticalPadding: CGFloat = 6
        static let borderWidth: CGFloat = 1
        static let contentSpacing: CGFloat = 2
        static let pastOpacity: Double = 0.45
        static let standardBackgroundOpacity: Double = 0.12
        static let activeBackgroundOpacity: Double = 0.25
        static let standardBorderOpacity: Double = 0.4
        static let blockedBackgroundOpacity: Double = 0.08
        static let blockedBorderOpacity: Double = 0.2
    }
}

// MARK: - Preview

#Preview("ScheduleCard") {
    let now = Date()
    let appointment = Appointment(
        startDate: now,
        endDate: now.addingTimeInterval(3600),
        status: .confirmed,
        client:  .init(name: "Caio", contactInfo: "99999999")
    )
        
    let blocked = Appointment(
        startDate: now,
        endDate: now.addingTimeInterval(3600),
        status: .blocked
    )

    VStack(spacing: 16) {
        ScheduleCard(appointment: appointment, state: .active) {_ in }
            .frame(height: 80)
        ScheduleCard(appointment: appointment, state: .standard) {_ in }
            .frame(height: 80)
        ScheduleCard(appointment: appointment, state: .past) {_ in }
            .frame(height: 80)
        ScheduleCard(appointment: blocked, state: .standard) {_ in }
            .frame(height: 40)
    }
    .padding()
    .background(Color(.systemBackground))
}
