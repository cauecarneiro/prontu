//
//  OnBoardingView.swift
//  Prontu!
//
//  Created by Luciana Liebl de Freitas on 27/04/26.
//
import SwiftUI

struct OnBoardingView: View{
    let pages: 
    @State private var currentPage = 0
    
    var body: some View{
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
        .tabViewStyle(.page)
        
    }//end body
    
    private func nextPage() {
        if currentPage < pages.count - 1 {
            currentPage += 1
        }
    }
}

    
//    //Lógica do timer
//    
//    //Chamada a cada tick de 0.05s
//    private func tick(){
//        
//        //Última tela nao tem auto-avanço
//        guard currentPage < pages.count else { return }
//        
//        // 5 segundos / 0.05 por tick = 100 ticks → incremento de 0.01 por tick
//        let increment = 0.05 / 5.0
//        
//        if progress + increment >= 1.0{
//            progress = 0
//            advance()
//        }else{
//            withAnimation(.linear(duration: 0.05)){
//                progress += increment
//            }
//        }
//    }
//    
//    private func advance(){
//        guard currentPage < total - 1 else { return }
//        withAnimation { currentPage += 1 }
//    }
//    
//}//end View
