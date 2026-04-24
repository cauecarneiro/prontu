//
//  WeeklyBarChart.swift
//  Challenge13
//
//  Created by Caio Mandarino on 23/04/26.
//

import Charts
import SwiftUI

struct WeeklyBarChart: View {

    let data: [ReportBarData]
    @Binding var selectedBarID: String

    private enum Layout {
        static let height: CGFloat = 180
        static let barCornerRadius: CGFloat = 8
        static let labelFontSize: CGFloat = 11
    }

    private var maxCount: Int { data.map(\.count).max() ?? 0 }
    private var highlightedBarID: String {
        if data.contains(where: { $0.id == selectedBarID }) {
            return selectedBarID
        }

        return data.first(where: \.isCurrentBucket)?.id ?? data.first?.id ?? ""
    }

    var body: some View {
        Chart(data) { item in
            BarMark(
                x: .value("Período", item.id),
                y: .value("Sessões", item.count)
            )
            .cornerRadius(Layout.barCornerRadius)
            .foregroundStyle(item.id == highlightedBarID ? GlobalConfiguration.primaryBlue : GlobalConfiguration.chartBarInactive)
            .accessibilityLabel(item.label)
            .accessibilityValue("\(item.count) sessões")
        }
        .chartXScale(domain: data.map(\.id))
        .chartYScale(domain: 0...max(maxCount, 1))
        .chartYAxis(.hidden)
        .chartXAxis {
            AxisMarks(values: data.map(\.id)) { value in
                if let id = value.as(String.self),
                   let item = data.first(where: { $0.id == id }) {
                    AxisValueLabel {
                        Text(item.label)
                            .font(.system(size: Layout.labelFontSize, weight: item.id == highlightedBarID ? .medium : .regular))
                            .foregroundStyle(item.id == highlightedBarID ? GlobalConfiguration.primaryBlue : Color.secondary)
                    }
                }
            }
        }
        .chartOverlay { proxy in
            GeometryReader { geometry in
                Rectangle()
                    .fill(.clear)
                    .contentShape(Rectangle())
                    .gesture(
                        SpatialTapGesture().onEnded { tap in
                            let plotFrame = geometry[proxy.plotAreaFrame]
                            let xPosition = tap.location.x - plotFrame.origin.x

                            guard xPosition >= 0, xPosition <= proxy.plotAreaSize.width else { return }
                            guard let tappedID = proxy.value(atX: xPosition, as: String.self) else { return }
                            guard data.contains(where: { $0.id == tappedID }) else { return }

                            selectedBarID = tappedID
                        }
                    )
            }
        }
        .frame(height: Layout.height)
    }
}

#Preview {
    WeeklyBarChart(data: [
        ReportBarData(
            id: "1",
            label: "Seg",
            count: 3,
            interval: .init(start: .now, duration: 1),
            isCurrentBucket: false
        ),
        ReportBarData(
            id: "2",
            label: "Ter",
            count: 5,
            interval: .init(start: .now, duration: 1),
            isCurrentBucket: false
        ),
        ReportBarData(
            id: "3",
            label: "Qua",
            count: 7,
            interval: .init(start: .now, duration: 1),
            isCurrentBucket: true
        )
    ], selectedBarID: .constant("3"))
    .padding()
}
