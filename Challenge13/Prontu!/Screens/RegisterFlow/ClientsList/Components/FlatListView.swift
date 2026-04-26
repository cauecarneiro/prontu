//
//  FlatListView.swift
//  Prontu!
//
//  Created by Luciana Liebl de Freitas on 24/04/26.
//

import SwiftUI
import Foundation

struct FlatListView: View{
    
    let clients: [Client]
    let scrollTargetLetter: String?
    let onTap: (Client) -> Void
    
    var body: some View{
        //ScrollView permite a scrolagem
        ScrollViewReader{ proxy in
            ScrollView{
                VStack(alignment: .leading, spacing: 0){
                    //ForEach repete o componente para cada cliente
                    ForEach(clients){ client in
                        Button{
                            onTap(client)
                        }label:{
                            ClientRow(client: client)
                        }
                        .buttonStyle(.plain)
                        .id(client.id)
                        
                        //adiciona o divisor menos no último
                        if client.id != clients.last?.id{
                            Divider()
                                .padding(.leading,70)
                                .padding(.trailing, 20)
                        }
                    }
                }
                .background(Color(.systemGray6))
                .cornerRadius(GlobalConfiguration.normalCornerRadius)
                .padding(.horizontal)
                .padding(.top, 8)
            }//end SrollView
            .onChange(of: scrollTargetLetter){ _, letter in
                guard let letter = letter else {return}
                
                //Primeiro cliente com a letra
                let target = clients.first{
                    $0.name.hasPrefix(letter)
                }
                
                //Scroll até ele
                if let target{
                    proxy.scrollTo(target.id, anchor: .top)
                }
            }
        }
    }//end body
}//end View

