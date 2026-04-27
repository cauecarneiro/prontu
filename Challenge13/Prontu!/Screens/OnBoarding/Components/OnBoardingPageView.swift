//
//  OnBoardingPageView.swift
//  Prontu!
//
//  Created by Luciana Liebl de Freitas on 27/04/26.
//
import SwiftUI

struct OnBoardingPageView: View{

    let page: OnBoardingPage

    var body: some View{
        VStack{
            Spacer()

            Image(page.image)
                .resizable()
                .scaledToFit()
                .frame(
                    width: page.image == "Calendar" ? 260 : 220,
                    height: page.image == "Calendar" ? 260 : 220
                )
                .offset(x: page.image == "Calendar" ? -18 : 0)
                .padding(.bottom, 40)

            Text(page.title)
                .font(.title2)
                .bold()
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Text(page.description)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .padding(.top, 12)

            Spacer()
        }
    }
}
