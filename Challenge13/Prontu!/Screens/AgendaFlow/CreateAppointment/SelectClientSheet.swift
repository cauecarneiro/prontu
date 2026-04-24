//
//  SelectClientSheet.swift
//  Challenge13
//
//  Created by Linda Marie Ribeiro Alves Correa dos Santos on 24/04/26.
//

import SwiftUI

struct SelectClientSheet: View {
    
    @ObservedObject var viewModel: CreateAppointmentViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    
                    ForEach(viewModel.clients) { client in
                        
                        Button {
                            viewModel.selectedClient = client
                            dismiss()
                        } label: {
                            ClientRow(client: client)
                        }
                        .buttonStyle(.plain)
                        
                        if client.id != viewModel.clients.last?.id {
                            Divider()
                                .padding(.leading, 70)
                        }
                    }
                }
                .background(Color(.systemGray6))
                .cornerRadius(GlobalConfiguration.normalCornerRadius)
                .padding()
            }
            .navigationTitle("Selecionar cliente")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
