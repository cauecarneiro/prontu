//
//  SessionHistoryCard.swift
//  Challenge13
//
//  Created by Cauê Carneiro on 24/04/26.
//

import SwiftUI

struct SessionHistoryCard: View {

    let appointment: Appointment

    private var statusLabel: String {
        switch appointment.status {
        case .finished:   return "Concluído"
        case .confirmed:  return "Confirmado"
        case .scheduled:  return "Agendado"
        case .cancelled:  return "Cancelado"
        case .blocked:    return "Bloqueado"
        }
    }

    private var statusColor: Color {
        switch appointment.status {
        case .finished:  return GlobalConfiguration.primaryGreen
        case .confirmed: return GlobalConfiguration.primaryBlue
        case .cancelled: return GlobalConfiguration.destructiveRed
        case .scheduled: return Color(uiColor: .systemGray)
        default:         return Color(uiColor: .systemGray2)
        }
    }

    private var dateText: String {
        appointment.startDate.formatted(.dateTime.day().month(.abbreviated).year())
    }

    private var timeRangeText: String {
        let start = appointment.startDate.formatted(.dateTime.hour().minute())
        let end   = appointment.endDate.formatted(.dateTime.hour().minute())
        return "\(start) – \(end)"
    }

    private var exerciseList: [String] {
        guard let raw = appointment.exercises, !raw.isEmpty else { return [] }
        return raw.components(separatedBy: " • ").map { $0.trimmingCharacters(in: .whitespaces) }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerRow
            Divider()
                .background(Color(red: 0.92, green: 0.92, blue: 0.92))
                .padding(.vertical, 12)

            detailContent
        }
        .padding(16)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: GlobalConfiguration.normalCornerRadius))
        .shadow(color: .black.opacity(0.06), radius: 12, y: 2)
    }

    // MARK: - Subviews

    private var headerRow: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 2) {
                Text(dateText)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Color(red: 0.10, green: 0.10, blue: 0.10))
                Text(timeRangeText)
                    .font(.system(size: 13))
                    .foregroundStyle(Color(red: 0.40, green: 0.40, blue: 0.40))
            }
            Spacer()
            statusBadge
        }
        .padding(.bottom, 12)
    }

    private var statusBadge: some View {
        HStack(spacing: 6) {
            if appointment.status == .finished {
                Circle()
                    .fill(statusColor.opacity(0.45))
                    .frame(width: 12, height: 12)
                    .overlay(
                        Circle()
                            .fill(statusColor)
                            .padding(2)
                    )
            }
            Text(statusLabel)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(statusColor)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(statusColor.opacity(0.10))
        .clipShape(Capsule())
    }

    @ViewBuilder
    private var detailContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            if !exerciseList.isEmpty {
                exercisesSection
            }
            if let notes = appointment.notes, !notes.isEmpty {
                observationsSection(notes)
            }
            if let equipment = appointment.equipment, !equipment.isEmpty {
                equipmentSection(equipment)
            }
        }
    }

    private var exercisesSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            sectionLabel("EXERCÍCIOS")
            VStack(alignment: .leading, spacing: 4) {
                ForEach(exerciseList, id: \.self) { exercise in
                    Text(exercise)
                        .font(.system(size: 13))
                        .foregroundStyle(Color(red: 0.20, green: 0.20, blue: 0.20))
                        .padding(.vertical, 4)
                }
            }
        }
    }

    private func observationsSection(_ text: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            sectionLabel("OBSERVAÇÕES")
            Text(text)
                .font(.system(size: 13))
                .foregroundStyle(Color(red: 0.27, green: 0.27, blue: 0.27))
        }
    }

    private func equipmentSection(_ text: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            sectionLabel("EQUIPAMENTOS")
            Text(text)
                .font(.system(size: 13))
                .foregroundStyle(Color(red: 0.27, green: 0.27, blue: 0.27))
        }
    }

    private func sectionLabel(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 11, weight: .semibold))
            .foregroundStyle(Color(red: 0.60, green: 0.60, blue: 0.60))
    }
}
