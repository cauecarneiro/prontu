//
//  AppointmentReportView.swift
//  Challenge13
//
//  Created by Caio Mandarino on 01/04/26.
//

import SwiftUI

struct AppointmentReportView: View {

    @ObservedObject var viewModel: AppointmentReportViewModel

    private enum Layout {
        static let toolbarIconFontSize: CGFloat = 17
        static let fabIconSize: CGFloat = 20
    }

    var body: some View {
        ScrollView {
            VStack(spacing: GlobalConfiguration.normalSpacing) {
                periodPicker

                HeroChartCard(
                    totalSessions: viewModel.totalSessions,
                    dateRangeLabel: viewModel.dateRangeLabel,
                    subtitle: viewModel.heroSubtitle,
                    barData: viewModel.chartData,
                    selectedBarID: $viewModel.selectedBarID
                )

                MetricGridCard(
                    sessions: viewModel.totalSessions,
                    sessionsCaption: viewModel.sessionsCaption,
                    hours: viewModel.totalHours,
                    hoursCaption: viewModel.hoursCaption,
                    averagePerDay: viewModel.averagePerDay,
                    clientsCount: viewModel.uniqueClientsCount
                )
            }
            .padding(GlobalConfiguration.normalSpacing)
        }
        .background(GlobalConfiguration.groupedBackground)
        .overlay(alignment: .bottomTrailing) {
            FloatingButton(systemImageName: "message.fill") {
                viewModel.presentToChatbot()
            }
            .padding(.horizontal, GlobalConfiguration.normalSpacing)
        }
        .navigationTitle("Relatórios")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                toolbarButton(icon: "person") {
                    viewModel.navigateToPreferences()
                }
            }
        }
    }

    private var periodPicker: some View {
        Picker("Período", selection: $viewModel.selectedPeriod) {
            ForEach(ReportPeriod.allCases, id: \.self) { period in
                Text(period.rawValue).tag(period)
            }
        }
        .pickerStyle(.segmented)
    }

    private func toolbarButton(icon: String, action: @escaping () -> Void = {}) -> some View {
        Button { action() } label: {
            Image(systemName: icon)
                .font(.system(size: Layout.toolbarIconFontSize, weight: .semibold))
                .foregroundStyle(Color.primary)
        }
        .buttonStyle(.plain)
    }
}

private func makePreviewCoordinator() -> (AppointmentReportFlowCoordinator, DatabaseService) {
    let db = makeRegisterFlowDatabaseService()
    return (AppointmentReportFlowCoordinator(factory: .init(databaseService: db)), db)
}

#Preview {
    let (coordinator, db) = makePreviewCoordinator()
    NavigationStack {
        AppointmentReportView(
            viewModel: .init(coordinator: coordinator, databaseService: db)
        )
    }
}
