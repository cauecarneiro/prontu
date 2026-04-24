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
                                    
                                    if let clients = viewModel.groupedClients[letter] {
                                        
                                        VStack(alignment: .leading, spacing: 0) {
                                            
                                            HStack{
                                                Text(letter)
                                                    .font(.title2)
                                                    .foregroundColor(Color.secondary)
                                                    .bold()
                                                
                                                Text("(\(clients.count))")
                                                    .foregroundColor(Color.secondary)
                                                
                                                Spacer()
                                            }
                                            .padding()
                                            
                                            //Lista de clientes
                                            ForEach(clients) { client in
                                                
                                                Button {
                                                    viewModel.navigateToEditClient(client: client)
                                                    } label: {
                                                        ClientRow(client: client)
                                                    }
                                                    .buttonStyle(.plain)
                                                
                                               //ClientRow(client: client)
                                               //viewModel.navigateToEditClient()
                                                
                                                if client.id != clients.last?.id {
                                                    Divider()
                                                        .padding(.leading, 70)
                                                        .padding(.trailing, 20)
                                                }
                                            }
                                        }
                                        .background(Color(.systemGray6))
                                        .cornerRadius(GlobalConfiguration.normalCornerRadius)
                                        .padding(.horizontal)
                                        .padding(.top, 8)
                                        .id(letter)
                                    }
                                }
                            }
                        }
                    }
                }
                
                // Index lateral com drag
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
        }//end ScrollView
        .background(Color(.systemGray5))
        .navigationTitle("Clientes")
        .navigationBarTitleDisplayMode(.large)
        .overlay(alignment: .bottomTrailing) {
            FloatingButton(systemImageName: "person.fill.badge.plus") {
                viewModel.presentCreateClient()
            }
            .padding(.horizontal, GlobalConfiguration.normalSpacing)
        }
        .searchable(text: $viewModel.search, placement: .navigationBarDrawer, prompt: "Buscar cliente")
    }//end body
}//end View

//#Preview {
//    ClientsListView(
//        viewModel: ClientsListViewModel(
//            coordinator:  RegisterFlowCoordinator(factory: .init(databaseService: .init(context: makeMainContext()))), databaseService: .init(context: makeMainContext())
//        )
//    )
//}
