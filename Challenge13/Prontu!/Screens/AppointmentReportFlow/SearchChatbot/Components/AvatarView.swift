//
//  AvatarView.swift
//  Challenge13
//
//  Created by Luciana Liebl de Freitas on 23/04/26.
//

import SwiftUI

struct AvatarView: View{
    
    var body: some View{
        ZStack {
            Circle()
                .fill(GlobalConfiguration.primaryBlue)
                .frame(width: 35, height: 35)
                .overlay(
                    Image(systemName: "apple.intelligence")
                        .foregroundColor(.white)
                       // .font(.custom("SFCompactRounded-Semibold", size: 11))
            )
        }
    }
}


