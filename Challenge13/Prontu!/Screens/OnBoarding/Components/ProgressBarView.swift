//
//  ProgressBarView.swift
//  Prontu!
//
//  Created by Luciana Liebl de Freitas on 27/04/26.
//
import SwiftUI

struct ProgressBarView: View{
    
    let total: Int
    let currentPage: Int
    let progress: Double
    
    var body: some View{
        HStack(spacing: 6){
            ForEach(0..<total, id: \.self){ i in
                Capsule()
                    .fill(Color(.systemGray4))
                    .overlay(alignment: .leading){
                        //Segmento cheio se já passou, parcial se é o atual
                        GeometryReader{ geo in
                            Capsule()
                                .fill(Color(GlobalConfiguration.primaryBlue))
                                .frame(width: geo.size.width * segmentFill(for: i))
                        }
                    }
                    .frame(height: 4)
            }
        }//end HStack barra de progresso
    }//end body
    
    //Quanto o segmento i deve estar preenchido
    private func segmentFill(foi i: Int) -> Double{
        if i < currentPage {return 1.0}  //Já passou: cheio
        if i == currentPage {return progress} //Atual: parcial
        return 0.0 //Futuro: vazio
    }
}//end View
