//
//  MetricGridCard.swift
//  Challenge13
//
//  Created by Caio Mandarino on 23/04/26.
//

import SwiftUI

struct MetricGridCard: View {

    let sessions: Int
    let sessionsCaption: String
    let hours: String
    let hoursCaption: String
    let averagePerDay: String
    let clientsCount: Int

    private enum Layout {
        static let horizontalPadding: CGFloat = 20
        static let verticalPadding: CGFloat = 8
        static let dividerVerticalHeight: CGFloat = 44
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                MetricCard(
                    label: "Sessões",
                    value: "\(sessions)",
                    caption: sessionsCaption.isEmpty ? nil : sessionsCaption
                )
                Divider()
                    .frame(height: Layout.dividerVerticalHeight)
                MetricCard(
                    label: "Horas",
                    value: hours,
                    caption: hoursCaption.isEmpty ? nil : hoursCaption
                )
            }
            .padding(.vertical, GlobalConfiguration.normalSpacing)

            Divider()

            HStack(spacing: 0) {
                MetricCard(
                    label: "Média/Dia",
                    value: averagePerDay,
                    caption: nil
                )
                Divider()
                    .frame(height: Layout.dividerVerticalHeight)
                MetricCard(
                    label: "Clientes",
                    value: "\(clientsCount)",
                    caption: nil
                )
            }
            .padding(.vertical, GlobalConfiguration.normalSpacing)
        }
        .padding(.horizontal, Layout.horizontalPadding)
        .padding(.vertical, Layout.verticalPadding)
        .background(GlobalConfiguration.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: GlobalConfiguration.normalCornerRadius))
    }
}

#Preview {
    MetricGridCard(
        sessions: 42,
        sessionsCaption: "+8 vs sem. ant.",
        hours: "38h",
        hoursCaption: "+3h",
        averagePerDay: "5.4h",
        clientsCount: 18
    )
    .padding()
    .background(GlobalConfiguration.groupedBackground)
}
