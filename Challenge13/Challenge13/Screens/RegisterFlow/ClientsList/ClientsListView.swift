//
//  ClientsListView.swift
//  Challenge13
//
//  Created by Caio Mandarino on 01/04/26.
//

import SwiftUI

struct ClientsListView: View {
    
    @ObservedObject var viewModel: ClientsListViewModel
    
    var body: some View {
        VStack {
            Text("Hello, ClientsListView!")
            
            Button("Navigate To Create Client") {
                viewModel.presentCreateClient()
            }
            
            Button("Navigate To Edit Client") {
                viewModel.navigateToEditClient(client: .init())
            }
        }
    }
}

#Preview {
    ClientsListView(viewModel: .init(coordinator: RegisterFlowCoordinator()))
}
