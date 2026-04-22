//
//  ClientsListView.swift
//  Challenge13
//
//  Created by Caio Mandarino on 01/04/26.
//

import SwiftUI

struct ClientsListView: View {
    
    @ObservedObject var viewModel: ClientsListViewModel
    
//    @State private var selectedLetter: String = ""
    @State private var showBubble: Bool = false
    
    var body: some View {
        
        ZStack {
            Color(.systemGray5).ignoresSafeArea()
            
            VStack(alignment: .leading) {
                
                HeaderClientsView(search: $viewModel.search)
                
                ScrollViewReader { proxy in
                    
                    ZStack {
                        
                        //EMPTY STATE
                        if viewModel.groupedClients.isEmpty {
                            EmptyStateView()
                                .frame(maxWidth: .infinity,
                                       maxHeight: .infinity,
                                       alignment: .top)
                        } else {
                            
                            //LISTA
                            ScrollView {
                                VStack(alignment: .leading) {
                                    
                                    ForEach(viewModel.groupedClients.keys.sorted(), id: \.self) { letter in
                                        
                                        VStack(alignment: .leading) {
                                            
                                            // HEADER LETRA
                                            Text(letter)
                                                .font(.headline)
                                                .padding(.top)
                                                .padding(.horizontal, 16)
                                                .id(letter)
                                            
                                            if let clients = viewModel.groupedClients[letter] {
                                                
                                                VStack(spacing: 0) {
                                                    
                                                    ForEach(clients) { client in
                                                        
                                                        ClientRow(client: client)
                                                        
                                                        if client.id != clients.last?.id {
                                                            Divider()
                                                                .padding(.leading, 70)
                                                        }
                                                    }
                                                }
                                                .background(Color(.systemGray6))
                                                .cornerRadius(20)
                                                .padding(.horizontal)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        // INDEX LATERAL (COM DRAG)
                        HStack {
                            Spacer()
                            
                            AlphabetIndexView(
                                letters: viewModel.groupedClients.keys.sorted()
                            ) { letter in
                                
                                withAnimation {
                                    proxy.scrollTo(letter, anchor: .top)
                                }
                            }
                            .padding(.trailing, 4)
                        }
                    }
                }
            }
        }
        .overlay(alignment: .bottomTrailing) {
            CreateClientButton {
                viewModel.presentCreateClient()
            }
            .padding(.trailing, 16)
            .padding(.bottom, 60)
        }
    }
}
