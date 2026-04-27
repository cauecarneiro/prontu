//
//  OnBoardingView.swift
//  Prontu!
//
//  Created by Luciana Liebl de Freitas on 27/04/26.
//
import SwiftUI
import Combine

struct OnBoardingView: View{
    
    @State private var currentPage = 0
    @State private var progress: Double = 0
    
    private let pages = OnBoardingPage.mock
    private var total: Int { pages.count }
    
    var body: some View{
        
        VStack{
            
            //Botão voltar e barra de progresso
            HStack{
                
                Button{
                    previousPage()
                }label: {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundStyle(.primary)
                }
                .opacity(currentPage == 0 ? 0 : 1)
                
                //Barra de progresso
                ProgressBarView(
                    total: total,
                    currentPage: currentPage,
                    progress: progress
                )
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            //Conteúdo das páginas
            TabView(selection: $currentPage){
                
                //Páginas normais
                ForEach(pages.indices, id: \.self){ i in
                    OnBoardingPageView(page:pages[i]){
                        nextPage()
                    }
                    .tag(i)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut, value: currentPage)
            
        }//Timer para auto avanço + animaçao da barra
        .onReceive(
            Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
        ){ _ in
            tick()
        }
        
        //Reset do progresso ao trocar de página
        .onChange(of: currentPage) { _ in
            progress = 0
        }
        
    }
    private func tick() {
        let step = 0.05 / 5.0  // timer dispara a cada 0.05s, fill em 5s
        if progress < 1.0 {
            progress = min(progress + step, 1.0)
        } else if currentPage < total - 1 {
            nextPage()
        }
    }

    //Funçao para passar a página
    private func nextPage() {
        if currentPage < total - 1 {
            currentPage += 1
        }
    }
    
    //Funçao para voltar a página
    private func previousPage(){
        if currentPage > 0 {
            currentPage -= 1
        }
    }
    
}







