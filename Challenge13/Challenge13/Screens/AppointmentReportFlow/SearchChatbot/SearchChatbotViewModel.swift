//
//  SearchChatbotViewModel.swift
//  Challenge13
//
//  Created by Caio Mandarino on 01/04/26.
//

import Combine
import SwiftData
import SwiftUI

//MARK: Tipos de chat
enum ChatAuthor{
    case hero
    case user
}

//MARK: opçoes do que o usuário quer que seja respondido
enum HeroSuggestionType: String, Hashable{
    case checkAvailableTimes
}

//MARK: botão clicável
struct HeroSuggestion: Identifiable, Hashable{
    //Qual opção o usuário quer
    let type: HeroSuggestionType
    //Texto mostrado
    let title: String
    //ID da opção
    var id: String {type.rawValue}
}

//MARK: mensagem do chat
struct MessageChat: Identifiable, Hashable{
    let id = UUID()
    let author: ChatAuthor
    let text: String
    let suggestions: [HeroSuggestion]
    
    init(author: ChatAuthor, text: String, suggestions: [HeroSuggestion] = []){
        self.author = author
        self.text = text
        self.suggestions = suggestions
    }
}

//MARK: View Model

//Classe reativa
@Observable
class SearchChatbotViewModel {
    
    //Lista do chat
    var messages: [MessageChat] = []
    
    //Texto digitado
    var typedText: String = ""
    
    //Indica se a IA está respondendo
    var loading: Bool = false
    
    //Valida botão enviar
    var canSend: Bool{
        //Só permite enviar se tem texto e se não está carregando
        !typedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !loading
    }
    
    init(){
        messages = [
            MessageChat(
                author: .hero,
                text: "Olá! Sou o Hero, seu assistente de agendamentos do FisioPlus. Posso te ajudar com informações sobre seus agendamentos. Como posso te ajudar?",
                suggestions: [
                    HeroSuggestion(
                        type: .checkAvailableTimes,
                        title: "Verificar horários disponíveis na semana"
                    )
                ]
            )
        ]
    }
    
    //MARK: Enviar mensagem para o chat
    func sendFreeMessage(appointments: [Appointment]){
        var appointments = Appointment.mockData()
        
        let question = typedText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !question.isEmpty else { return }
        
        typedText = ""
        messages.append(MessageChat(author: .user, text: question))
        answer(question: question, appointments: appointments)
    }
    
    //MARK: selecionar sugestão quando o user clica no botão
    func selectSuggestion(_ suggestion: HeroSuggestion, appointment: [Appointment]){
        //Mostra a escolha no chat
        messages.append(MessageChat(author: .user, text: suggestion.title))
        
        //Decide o que fazer
        switch suggestion.type{
        //Ações específicas
        case .checkAvailableTimes:
            //Manda o prompt  para a IA
            answer(
                question: "Verifique os horários disponíveis dentro do horário comercial (08:00 às 18:00) com base no agendamentos cadastrados.",
                appointments: appointment
            )
        }
    }
    
    //MARK: Lógica
    private func answer(question: String, appointments: [Appointment]){
        
        //Ativa o "digitando..."
        loading = true
        
        //Executa o async
        Task{
            do{
                //Cria o prompt
                let prompt = createPrompt(question: question, appointments: appointments)
                //Chama IA
                let response = try await IAService.createText(prompt: prompt)
                
                await MainActor.run{
                    //Adicionar resposta
                    messages.append(MessageChat(author: .hero, text: response))
                    //Para o "digitando..."
                    loading = false
                }
            }catch{
                await MainActor.run{
                    messages.append(MessageChat(author: .hero, text: "Não consegui processar sua solicitação. Tente novamente."
                    ))
                    loading = false
                }
            }
        }
    }
    
    //MARK: Engenharia de Prompt
    private func createPrompt(question: String, appointments: [Appointment]) -> String{
        
        for appointment in appointments {
           
        }
        //Injeta dados do app e pergunta do user
        """
        Agendamentos cadastrados:
        \(appointments)
        
        
        Pergunta: \(question)
        """
    }
    
    //MARK: transforma dados em texto
    private func createContext(_ appointments: [Appointment]) -> String{
        guard !appointments.isEmpty else{
            return "Nenhum agendamento cadastrado"
        }
        
        //Padrão para formatar data
        let iso = ISO8601DateFormatter()
        
        return appointments
            .sorted { $0.startDate < $1.startDate }
            //Transforma cada agendamento em texto para a IA entender
            .map { ag in
                let data = iso.string(from: ag.startDate)
                return "Data: \(data)"
               // let obs = ag.observacao.flatMap { $0.isEmpty ? nil : $0 } ?? "Sem observação"
               // return "• Título: \(ag.titulo) | Data: \(data) | Observação: \(obs)"
            }
            .joined(separator: "\n")
    }
}
