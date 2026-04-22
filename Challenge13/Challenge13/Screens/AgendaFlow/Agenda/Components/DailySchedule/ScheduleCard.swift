//
//  ScheduleCard.swift
//  Challenge13
//
//  Created by Caio Mandarino on 15/04/26.
//

import SwiftUI

struct ScheduleCard: View {
    let appointment: Appointment
    let lineWidth: CGFloat
    let navigateTo: (Appointment) -> Void
    
    var color: Color {
        if isBlocked {
            return .gray
        }
        return appointment.status == .finished ? GlobalConfiguration.primaryGreen : GlobalConfiguration.primaryBlue
    }
    
    private var isBlocked: Bool {
        appointment.status == .blocked
    }

    private var style: ScheduleCardStyle {
        .init(
            backgroundColor: color.opacity(Layout.backgroundOpacity),
            borderColor: color.opacity(Layout.borderOpacity),
            opacity: 1
        )
    }

    var body: some View {
        HStack(spacing: GlobalConfiguration.normalSpacing) {
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: GlobalConfiguration.normalCornerRadius)
                    .foregroundStyle(.secondary.opacity(0.25))
                    .frame(maxWidth: lineWidth, maxHeight: .infinity)
                
                Circle()
                    .fill(color)
                    .frame(maxWidth: lineWidth * 2)
                    .offset(y: 10)
            }
            
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
                    if appointment.status != .finished {
                        navigateTo(appointment)
                    }
                }
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
        VStack(alignment: .leading, spacing: GlobalConfiguration.normalSpacing) {
            HStack(spacing: Layout.contentSpacing) {
                
                if let clientName = appointment.client?.name {
                    Text(clientName)
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                HStack {
                    Circle()
                        .frame(width: 8, height: 8)
                    
                    Text(statusLabel)
                        .font(.caption2)
                }
                .fontWeight(.medium)
                .foregroundStyle(color)
                .padding(4)
                .padding(.horizontal, 4)
                .background {
                    Capsule()
                        .fill(color.opacity(0.1))
                }
            }
            
            timeRow()
        }
        .padding(12)
    }

    private var blockedContent: some View {
        HStack(spacing: Layout.contentSpacing) {
            Image(systemName: "lock.fill")
                .font(.caption2)
                .foregroundStyle(.secondary)

            timeRow()
        }
    }

    private func timeRow() -> some View {
        HStack(spacing: Layout.contentSpacing) {
            Text(startTimeLabel)

            Text(" - ")
            
            Text(endTimeLabel)
                
        }
        .font(.caption)
        .foregroundStyle(.secondary)
    }

    private var startTimeLabel: String {
        Self.timeFormatter.string(from: appointment.startDate)
    }

    private var endTimeLabel: String {
        Self.timeFormatter.string(from: appointment.endDate)
    }

    private var statusLabel: String {
        if appointment.startDate < Date() && appointment.endDate > Date() {
            return "Em andamento"
        }
        
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

        init(backgroundColor: Color, borderColor: Color, opacity: Double) {
            self.backgroundColor = backgroundColor
            self.borderColor = borderColor
            self.opacity = opacity
        }
    }

    private enum Layout {
        static let horizontalPadding: CGFloat = 8
        static let verticalPadding: CGFloat = 6
        static let borderWidth: CGFloat = 1
        static let contentSpacing: CGFloat = 2
        static let backgroundOpacity: Double = 0.12
        static let borderOpacity: Double = 0.4
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
        ScheduleCard(appointment: appointment, lineWidth: 10) {_ in }
            .frame(height: 80)
        ScheduleCard(appointment: appointment, lineWidth: 10) {_ in }
            .frame(height: 80)
        ScheduleCard(appointment: appointment, lineWidth: 10) {_ in }
            .frame(height: 80)
        ScheduleCard(appointment: blocked, lineWidth: 10) {_ in }
            .frame(height: 40)
    }
    .padding()
    .background(Color(.systemBackground))
}
