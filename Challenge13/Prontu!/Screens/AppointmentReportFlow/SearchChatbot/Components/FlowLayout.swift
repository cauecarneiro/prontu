//
//  FlowLayout.swift
//  Challenge13
//
//  Created by Luciana Liebl de Freitas on 23/04/26.
//
import SwiftUI

/*
 Layout é um protocolo SwiftUI que dá controle total sobre:
 - tamanho da view
 - posiçao de cada sibview
 */

struct FlowLayout: Layout{
    
    //Espaço horizontal entre os itens
    var spacing: CGFloat = 8
    
    //Espaço vertical entre linhas
    var lineSpacing: CGFloat = 8
    
    //Funçao para struct se conformar com o protocolo Layout
    //Essa funçao determina qual o tamanho que essa view precisa ocupar
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        
        //proposal.width: largura disponivel da tela
        //é o limite para quebra de linha
        let maxWidth = proposal.width ?? 0
        
        //Posiçao horizontal atual
        var currentX: CGFloat = 0
        
        //Posiçao vertical atual
        var currentY: CGFloat = 0
        
        //Altura da linha atual
        var rowHeight: CGFloat = 0
        
        //Percorre cada botão/chip de sugestão
        for view in subviews{
            
            //Verifica o tamanho natural do botão para respeitar o texto real
            let size = view.sizeThatFits(.unspecified)
            
            //Se eu colocar esse item, ele ultrapassa a largura da tela?
            if currentX + size.width > maxWidth{
                //Se sim: quebra a linha
                //Volta para o inicio da linha
                currentX = 0
                //Desce uma linha
                currentY += rowHeight + lineSpacing
                //Reseta a altura da linha
                rowHeight = 0
            }
            
            //Atualiza a altura da linha
            rowHeight = max(rowHeight, size.height)
            //Move o cursor para o próximo espaço
            currentX += size.width + spacing
        }
        
        //largura = largura disponível
        //altura = soma de todas as linhas
        return CGSize(width: maxWidth, height: currentY + rowHeight)
    }//end sizeThatFits
    
    
    //Funçao para struct se conformar com o protocolo Layout
    //Função para posicionar os elementos na tela
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        
        //Agrupar em linhas
        //Array de linhas
        var rows: [[LayoutSubview]] = []
        
        //Linha atual
        var currentRow: [LayoutSubview] = []
        
        var currentWidth: CGFloat = 0
        
        for view in subviews{
            
            //Verifica o tamanho natural do botão para respeitar o texto real
            let size = view.sizeThatFits(.unspecified)
            
            //Quebra de linha
            if currentWidth + size.width > bounds.width{
                //Se não cabe, cria uma nova linha
                rows.append(currentRow)
                currentRow = [view]
                currentWidth = size.width + spacing
                
            } else {
                //Se cabe
                currentRow.append(view)
                currentWidth += size.width + spacing
            }
        }
        
        //Adiciona a última linha
        if !currentRow.isEmpty{
            rows.append(currentRow)
        }
        
        //Posicionar na tela
        //Começa no topo
        var y: CGFloat = bounds.minY
           
        //Loop das linhas
        for row in rows {
            
            //Calcula a largura da linha
            let rowWidths = row.map { $0.sizeThatFits(.unspecified).width}
           
            //soma largura de todos os itens e soma os espaçamentos
            let totalWidth = rowWidths.reduce(0, +) + CGFloat(row.count - 1) * spacing
            
            //Alinhamento à direita
            var x = bounds.maxX - totalWidth
            
            //Altura da linha
            var rowHeight: CGFloat = 0
            
            //Loop nos itens da linha
            for view in row{
                
                //Tamanho do item
                let size = view.sizeThatFits(.unspecified)
                
                //Pociona o item na tela
                view.place(
                    at: CGPoint(x: x, y: y),
                    proposal: ProposedViewSize(size)
                )
                
                //Move o cursor
                x += size.width + spacing

                //Atualiza a altura
                rowHeight = max(rowHeight, size.height)
            }
            
            //Próxima linha
            y += rowHeight + lineSpacing
            
        }
        
    }//end placeSubviews
}//end Layout
