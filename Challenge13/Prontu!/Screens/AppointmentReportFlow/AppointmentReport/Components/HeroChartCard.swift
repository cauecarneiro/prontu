//
//  HeroChartCard.swift
//  Challenge13
//
//  Created by Caio Mandarino on 23/04/26.
//

import SwiftUI

struct HeroChartCard: View {

    let totalSessions: Int
    let dateRangeLabel: String
    let subtitle: String
    let barData: [ReportBarData]
    @Binding var selectedBarID: String

    private enum Layout {
        static let padding: CGFloat = 20
        static let totalFontSize: CGFloat = 34
        static let subtitleFontSize: CGFloat = 15
        static let dateRangeFontSize: CGFloat = 13
    }

    var body: some View {
        VStack(alignment: .leading, spacing: GlobalConfiguration.normalSpacing) {
            HStack(alignment: .firstTextBaseline) {
                Text("\(totalSessions)")
                    .font(.system(size: Layout.totalFontSize, weight: .bold))
                    .foregroundStyle(Color.primary)
                Spacer()
                Text(dateRangeLabel)
                    .font(.system(size: Layout.dateRangeFontSize))
                    .foregroundStyle(Color.secondary)
            }

            Text(subtitle)
                .font(.system(size: Layout.subtitleFontSize))
                .foregroundStyle(Color.secondary)

            WeeklyBarChart(data: barData, selectedBarID: $selectedBarID)
        }
        .padding(Layout.padding)
        .background(GlobalConfiguration.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: GlobalConfiguration.normalCornerRadius))
    }
}

#Preview {
    HeroChartCard(
        totalSessions: 42,
        dateRangeLabel: "16–22 Abr",
        subtitle: "Sessões desta semana",
        barData: [
            ReportBarData(id: "1", label: "Seg", count: 3, interval: .init(start: .now, duration: 1), isCurrentBucket: false),
            ReportBarData(id: "2", label: "Ter", count: 5, interval: .init(start: .now, duration: 1), isCurrentBucket: false),
            ReportBarData(id: "3", label: "Qua", count: 7, interval: .init(start: .now, duration: 1), isCurrentBucket: true),
            ReportBarData(id: "4", label: "Qui", count: 4, interval: .init(start: .now, duration: 1), isCurrentBucket: false),
            ReportBarData(id: "5", label: "Sex", count: 6, interval: .init(start: .now, duration: 1), isCurrentBucket: false),
            ReportBarData(id: "6", label: "Sáb", count: 2, interval: .init(start: .now, duration: 1), isCurrentBucket: false),
            ReportBarData(id: "7", label: "Dom", count: 1, interval: .init(start: .now, duration: 1), isCurrentBucket: false)
        ],
        selectedBarID: .constant("3")
    )
    .padding()
    .background(GlobalConfiguration.groupedBackground)
}
