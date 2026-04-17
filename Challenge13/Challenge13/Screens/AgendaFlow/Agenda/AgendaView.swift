//
//  AgendaView.swift
//  Challenge13
//
//  Created by Caio Mandarino on 01/04/26.
//

import SwiftUI

struct AgendaView: View {
    @ObservedObject var viewModel: AgendaViewModel

    var body: some View {
        VStack(spacing: GlobalConfiguration.normalSpacing) {
            CalendarWeeklyStrip(
                selectedDate: $viewModel.selectedDate,
                appointments: viewModel.appointments
            )

            DailyScheduleCanvas(
                appointments: viewModel.dailyAppointments,
                date: viewModel.selectedDate
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .padding(.horizontal, GlobalConfiguration.normalSpacing)
    }
}

#Preview {
    let coordinator = makeAgendaFlowCoordinator()
    let databaseService = DatabaseService(context: makeMainContext())
    
    AgendaView(
        viewModel: .init(
            coordinator: coordinator,
            databaseService: databaseService,
            settingsStore: .shared
        )
    )
}
