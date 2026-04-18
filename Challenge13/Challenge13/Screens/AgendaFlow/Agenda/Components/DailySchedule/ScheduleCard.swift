//
//  ScheduleCard.swift
//  Challenge13
//
//  Created by Caio Mandarino on 15/04/26.
//

import SwiftUI

// MARK: - ScheduleCardState

enum ScheduleCardState {
    case standard
    case active
    case past
}

// MARK: - ScheduleCard

struct ScheduleCard: View {
    let appointment: Appointment
    let state: ScheduleCardState

    var body: some View {
        cardContent
            .padding(.horizontal, Layout.horizontalPadding)
            .padding(.vertical, Layout.verticalPadding)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background(backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: Layout.cornerRadius)
                    .strokeBorder(borderColor, lineWidth: Layout.borderWidth)
            )
            .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadius))
            .opacity(state == .past ? Layout.pastOpacity : 1.0)
    }

    // MARK: - Content

    @ViewBuilder
    private var cardContent: some View {
        if appointment.status == .blocked {
            blockedContent
        } else {
            appointmentContent
        }
    }

    private var appointmentContent: some View {
        VStack(alignment: .leading, spacing: Layout.contentSpacing) {
            HStack(spacing: Layout.contentSpacing) {
                Text(startTimeLabel)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(GlobalConfiguration.primaryBlue)

                Text(durationLabel)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if let name = appointment.client?.name {
                Text(name)
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

            Text(startTimeLabel)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            Text(durationLabel)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Visual State

    private var backgroundColor: Color {
        switch appointment.status {
        case .blocked:
            return Color.secondary.opacity(Layout.blockedBackgroundOpacity)
        default:
            switch state {
            case .standard, .past:
                return GlobalConfiguration.primaryBlue.opacity(Layout.standardBackgroundOpacity)
            case .active:
                return GlobalConfiguration.primaryBlue.opacity(Layout.activeBackgroundOpacity)
            }
        }
    }

    private var borderColor: Color {
        switch appointment.status {
        case .blocked:
            return Color.secondary.opacity(Layout.blockedBorderOpacity)
        default:
            switch state {
            case .standard, .past:
                return GlobalConfiguration.primaryBlue.opacity(Layout.standardBorderOpacity)
            case .active:
                return GlobalConfiguration.primaryBlue
            }
        }
    }

    // MARK: - Labels

    private var startTimeLabel: String {
        Self.timeFormatter.string(from: appointment.startDate)
    }

    private var durationLabel: String {
        let minutes = Int(appointment.endDate.timeIntervalSince(appointment.startDate) / 60)
        guard minutes > 0 else { return "0min" }
        if minutes >= 60 {
            let hours = minutes / 60
            let remainder = minutes % 60
            return remainder > 0 ? "\(hours)h \(remainder)min" : "\(hours)h"
        }
        return "\(minutes)min"
    }

    private var statusLabel: String {
        switch appointment.status {
        case .scheduled:    return "Aguardando"
        case .confirmed:  return "Confirmado"
        case .finished:   return "Finalizado"
        case .cancelled:  return "Cancelado"
        case .blocked:    return "Bloqueio"
        }
    }

    // MARK: - Formatters

    private static let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "pt_BR")
        f.dateFormat = "HH:mm"
        return f
    }()

    // MARK: - Layout

    private enum Layout {
        static let cornerRadius: CGFloat = GlobalConfiguration.normalCornerRadius
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
        status: .confirmed
    )
    let blocked = Appointment(
        startDate: now.addingTimeInterval(7200),
        endDate: now.addingTimeInterval(9000),
        status: .blocked
    )

    VStack(spacing: 16) {
        ScheduleCard(appointment: appointment, state: .active)
            .frame(height: 80)
        ScheduleCard(appointment: appointment, state: .standard)
            .frame(height: 80)
        ScheduleCard(appointment: appointment, state: .past)
            .frame(height: 80)
        ScheduleCard(appointment: blocked, state: .standard)
            .frame(height: 40)
    }
    .padding()
    .background(Color(.systemBackground))
}
