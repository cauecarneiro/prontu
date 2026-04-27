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
                        GeometryReader{ geo in
                            Capsule()
                                .fill(Color(GlobalConfiguration.primaryBlue))
                                .frame(width: geo.size.width * segmentFill(for: i))
                                .animation(.linear(duration: 0.05), value: progress)
                        }
                    }
                    .frame(height: 4)
            }
        }//end HStack barra de progresso
    }//end body
    
    private func segmentFill(for i: Int) -> Double {
        if i < currentPage { return 1.0 }
        if i == currentPage { return progress }
        return 0.0
    }
}//end View
