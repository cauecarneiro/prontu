//
//  AppointmentDetailsStatusView.swift
//  Challenge13
//
//  Created by Codex on 26/04/26.
//

import SwiftUI

struct AppointmentDetailsStatusView: View {

    let status: AppointmentStatus

    private var title: String {
        switch status {
        case .scheduled:
            return "Agendado"
        case .confirmed:
            return "Confirmado"
        case .cancelled:
            return "Cancelado"
        case .finished:
            return "Concluído"
        case .blocked:
            return "Bloqueado"
        }
    }

    private var color: Color {
        switch status {
        case .scheduled:
            return GlobalConfiguration.primaryBlue
        case .confirmed:
            return GlobalConfiguration.primaryBlue
        case .cancelled:
            return GlobalConfiguration.destructiveRed
        case .finished:
            return GlobalConfiguration.primaryGreen
        case .blocked:
            return GlobalConfiguration.neutralGray
        }
    }

    var body: some View {
        HStack {
            circleMark

            Text(title)
                .foregroundStyle(color)
        }
        .padding(.horizontal, GlobalConfiguration.Layout.sectionSpacing)
        .padding(GlobalConfiguration.Layout.sectionSpacing)
        .background {
            ZStack {
                Capsule()
                    .fill(color.opacity(0.1))

                Capsule()
                    .stroke(lineWidth: 1)
                    .foregroundStyle(color)
            }
        }
    }

    private var circleMark: some View {
        ZStack {
            Circle()
                .frame(maxWidth: 10)
                .foregroundStyle(color)
                .padding(4)
                .background {
                    Circle()
                        .foregroundStyle(color.opacity(0.25))
                }
        }
    }
}
