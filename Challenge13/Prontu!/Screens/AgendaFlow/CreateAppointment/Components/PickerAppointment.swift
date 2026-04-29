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
    
    @Binding var selectedDate: Date
    @Binding var selectedStartTime: Date
    @Binding var selectedDuration: Int
    @Binding var selectedFrequency: Frequency
    
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
//            Divider() // TODO: Ainda não foi decidido como vai funcionar a frequência
            
//            AppointmentDetailsCardRow(title: frequencyLabel) {
//                Picker("", selection: $selectedFrequency) {
//                    ForEach(Frequency.allCases) { frequency in
//                        Text(frequency.rawValue)
//                            .tag(frequency)
//                    }
//                }
//            }
        }
        .tint(.gray)
        .fontWeight(.semibold)
        .padding()
        .background{
            RoundedRectangle(cornerRadius: GlobalConfiguration.normalCornerRadius)
                .fill(.white)
        }
    }
}

