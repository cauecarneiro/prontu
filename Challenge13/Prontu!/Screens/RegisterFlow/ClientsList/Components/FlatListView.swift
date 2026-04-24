//
//  FlatListView.swift
//  Prontu!
//
//  Created by Luciana Liebl de Freitas on 24/04/26.
//

import SwiftUI

struct FlatListView: View{
    
    let clients: [Client]
    let onTap: (Client) -> Void
    
    var body: some View{
        //ScrollView permite a scrolagem
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
    }//end body
}//end View

