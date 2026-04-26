//
//  AlphabetIndexView.swift
//  Challenge13
//
//  Created by Luciana Liebl de Freitas on 22/04/26.
//

import SwiftUI
import Foundation

//struct AlphabetIndexView: View{
//    
//    //map pega cada elemento do array e transforma
//    //$0 pega o elemento atual
//    //String($0) converte caracter para String
//    let letters = Array("ABCDEFGHIJKLMNOPQRSTUVXWYZ#").map { String($0) }
//    
//    var selectedLetter: String
//    
//    var onSelect: (String) -> Void
//    
//    var body: some View{
//        
//        GeometryReader{ geo in
//            VStack(spacing: 1){
//                ForEach(letters, id: \.self){
//                    letter in
//                    
//                    Text(letter)
//                        .font(.caption2)
//                        .foregroundColor(.blue)
//                        .scaleEffect(selectedLetter == letter ? 1.4 : 1.0)
//                        .frame(width: 20, height: 16)
//                }
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            
//            .gesture(
//                DragGesture(minimumDistance: 0)
//                    .onChanged { value in
//                        
//                        let totalHeight = geo.size.height
//                        let itemHeight = totalHeight / CGFloat(letters.count)
//                        
//                        let index = Int(value.location.y / itemHeight)
//                        
//                        if index >= 0 && index < letters.count {
//                            let letter = letters[index]
//                            onSelect(letter)
//                        }
//                    }
//            )//end GeometryReader
//        }//end body
//        .frame(width: 30)
//    }//end View
//}

struct AlphabetIndexView: View {
    
    let letters: [String]
    let onSelect: (String) -> Void
    let onReleased: ((String) -> Void)?

    @State private var activeLetter: String? = nil

    private let itemHeight: CGFloat = 16
    private let itemSpacing: CGFloat = 3

    var body: some View {
        VStack(spacing: itemSpacing) {
            ForEach(letters, id: \.self) { letter in
                Text(letter)
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(
                        letter == activeLetter
                            ? Color.blue
                            : Color.gray
                    )
                    .frame(width: 18, height: itemHeight)
                    .scaleEffect(letter == activeLetter ? 1.25 : 1.0)
                    .animation(.spring(response: 0.15), value: activeLetter)
            }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Navegação por letra")
        .accessibilityHint("Deslize para navegar entre seções da lista")
        .gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onChanged { value in
                    let offset = max(0, value.location.y - 4)
                    let index = min(Int(offset / (itemHeight + itemSpacing)), letters.count - 1)
                    let letter = letters[max(0, index)]
                    guard letter != activeLetter else { return }
                    activeLetter = letter
                    onSelect(letter)
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
                .onEnded { _ in
                    if let letter = activeLetter{
                        onReleased?(letter)
                    }
                    withAnimation(.spring(response: 0.2)) { activeLetter = nil }
                }
        )
    }
}
