//
//  AppointmentDetailsCardRow.swift
//  Challenge13
//
//  Created by Caio Mandarino on 23/04/26.
//

import SwiftUI

struct AppointmentDetailsCardRow<Content: View>: View {
    
    let title: String
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        HStack {
            Text(title)
                .fontWeight(.semibold)
            
            Spacer()
            
            content()
        }
        .padding(4)
    }
}

#Preview {
    AppointmentDetailsCardRow(title: "Test") {
        
    }
}
