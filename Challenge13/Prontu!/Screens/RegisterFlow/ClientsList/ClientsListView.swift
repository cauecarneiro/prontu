//
//  ClientsListView.swift
//  Challenge13
//
//  Created by Caio Mandarino on 01/04/26.
//

import SwiftUI

struct ClientsListView: View {
    
    @ObservedObject var viewModel: ClientsListViewModel
    @State private var isGrouped: Bool = false
    @State private var scrollTargetLetter: String? = nil
    
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
                    
                    if isGrouped{
                        GroupedListView(
                            groupedClients: viewModel.groupedClients,
                            onTap: {
                                client in viewModel.navigateToEditClient(client: client)
                            }
                        )
                    }else{
                        FlatListView(
                            clients: viewModel.allClientsSorted,
                            scrollTargetLetter: scrollTargetLetter, //passa a letra
                            onTap: { client in
                                viewModel.navigateToEditClient(client: client)
                                
                            }
                        )
                    }
                    
                    // Index lateral com drag
                    HStack {
                        Spacer()
                        
                        AlphabetIndexView(
                            letters: viewModel.groupedClients.keys.sorted(),
                            onSelect: { letter in
                                if !isGrouped {
                                    isGrouped = true
                                }
                                withAnimation {
                                    proxy.scrollTo(letter, anchor: .top)
                                }
                            },
                            onReleased: { letter in
                                scrollTargetLetter = letter//guarda a primeira letra
                                withAnimation {
                                    isGrouped = false  //volta para flat
                                }
                            }
                        
                        )
                    }
                    .padding(.trailing, 4)
                }//fecha else grande
            }//fecha Ztack
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
        .onChange(of: viewModel.search){
            if viewModel.search.isEmpty{
                isGrouped = false
            }
        }
        .onAppear{
            isGrouped = false
        }
    }//end body
}//end View

#Preview {
    let context = makeMainContext()
    let databaseService = DatabaseService(context: context)
    
    ClientsListView(
        viewModel: ClientsListViewModel(
            coordinator: RegisterFlowCoordinator(
                factory: .init(databaseService: databaseService)
            ),
            databaseService: databaseService
        )
    )
}
