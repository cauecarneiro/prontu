//
//  PickerAppointment.swift
//  Challenge13
//
//  Created by Linda Marie Ribeiro Alves Correa dos Santos on 22/04/26.
//

import SwiftUI


struct AppointmentPickerList: View {
    
    private let dateLabel = "Data"
    private let startTimeLabel = "Horário de início"
    private let durationLabel = "Duração"
    private let frequencyLabel = "Frequência"
    
    enum Frequency: String, CaseIterable, Identifiable {
        
        var id: String { rawValue }
        
        case nunca = "Nunca"
        case semanal = "Semanal"
        case quinzenal = "Quinzenal"
        case mensal = "Mensal"
        
    }
    @State private var selectedDate = Date()
    @State private var selectedStartTime = Date()
    @State private var selectedDuration = 60
    @State private var selectedFrequency: Frequency = .nunca
    
    let durationOptions = [30,60,90,120]
    
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            AppointmentDetailsCardRow(title: dateLabel) {
                DatePicker(
                    "",
                    selection: $selectedDate,
                    in: Date()...,
                    displayedComponents: .date
                )
            }
            Divider()
            
            AppointmentDetailsCardRow(title: startTimeLabel) {
                DatePicker(
                    "",
                    selection: $selectedStartTime,
                    displayedComponents: .hourAndMinute
                )
            }
            Divider()
            
            AppointmentDetailsCardRow(title: durationLabel) {
                Picker("", selection: $selectedDuration) {
                    ForEach(durationOptions, id: \.self) { duration in
                        Text("\(duration) min")
                    }
                }
            }
            Divider()
            
            AppointmentDetailsCardRow(title: frequencyLabel) {
                Picker("", selection: $selectedFrequency) {
                    ForEach(Frequency.allCases) { frequency in
                        Text(frequency.rawValue)
                            .tag(frequency)
                    }
                }
            }
        }
        .fontWeight(.semibold)
        .padding()
        .background{
            RoundedRectangle(cornerRadius: GlobalConfiguration.normalCornerRadius)
                .fill(.white)
        }
    }
}

#Preview {
    AppointmentPickerList()
}
