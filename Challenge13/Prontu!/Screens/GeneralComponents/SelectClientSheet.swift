//
//  SelectClientSheet.swift
//  Challenge13
//
//  Created by Linda Marie Ribeiro Alves Correa dos Santos on 24/04/26.
//

import SwiftUI

@MainActor
protocol ClientSelectionViewModel: ObservableObject {
    var clients: [Client] { get }
    var selectedClient: Client? { get set }
}

struct SelectClientSheet<ViewModel: ClientSelectionViewModel>: View {

    @ObservedObject var viewModel: ViewModel
    @Environment(\.dismiss) private var dismiss

    private struct Layout {
        let listSpacing: CGFloat = 0
        let dividerLeadingPadding: CGFloat = 70
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Layout().listSpacing) {

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
                                .padding(.leading, Layout().dividerLeadingPadding)
                        }
                    }
                }
                .background(GlobalConfiguration.secondaryGroupedBackground)
                .cornerRadius(GlobalConfiguration.normalCornerRadius)
                .padding()
            }
            .navigationTitle("Selecionar cliente")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .fontWeight(.semibold)
                    }
                    .tint(.black)
                }
            }
        }
    }
}

extension CreateAppointmentViewModel: ClientSelectionViewModel {}
