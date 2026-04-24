//
//  GroupedListView.swift
//  Prontu!
//
//  Created by Luciana Liebl de Freitas on 24/04/26.
//
import SwiftUI

struct GroupedListView: View{
    
    let groupedClients: [String: [Client]]
    let onTap: (Client) -> Void
    
    var body: some View{
        
        ScrollView {
            
            VStack(alignment: .leading) {
                
                ForEach(groupedClients.keys.sorted(), id: \.self) { letter in
                    
                    VStack(alignment: .leading) {
                        
                        if let clients = groupedClients[letter] {
                            
                            VStack(alignment: .leading, spacing: 0) {
                                
                                //Cabeçalho da letra
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
                                
                                //Lista de clientes do grupo
                                ForEach(clients) { client in
                                    
                                    Button {
                                        onTap(client)
                                    } label: {
                                        ClientRow(client: client)
                                    }
                                    .buttonStyle(.plain)
                                    
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
    }//end body
}//end View
