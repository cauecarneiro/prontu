//
//  SearchChatbotViewModel.swift
//  Challenge13
//
//  Created by Caio Mandarino on 01/04/26.
//

import Combine
import SwiftData
import SwiftUI

//MARK: View Model
class SearchChatbotViewModel: ObservableObject {
        
    //Lista do chat
    @Published var messages: [MessageChat]
    
    @Published var typedText: String = ""
    @Published var loading: Bool = false
    @Published var appointments: [Appointment]
    
    var canSend: Bool{
        !typedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !loading
    }
    
    private var cancellable: Set<AnyCancellable> = []
    
    init(appointments: [Appointment]){
        self.messages = [
            MessageChat(
                author: .hero,
                text: "Olá! Sou o Hero, seu assistente de agendamentos do FisioPlus. Posso te ajudar com informações sobre seus agendamentos. Como posso te ajudar?",
                suggestions: [
                    HeroSuggestion(
                        type: .checkAvailableTimes,
                        title: "Verificar horários disponíveis"
                    )
                ]
            )
        ]
        
        self.appointments = appointments
    }
    
    
    //MARK: Enviar mensagem para o chat
    func sendFreeMessage(appointments: [Appointment]){

        #if DEBUG
        let appointments = Appointment.mockData() // TODO: Remover
        #endif
        
        let question = typedText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !question.isEmpty else { return }
        
        typedText = ""
        messages.append(MessageChat(author: .user, text: question))
        answer(question: question, appointments: appointments)
    }
    
    //MARK: selecionar sugestão quando o user clica no botão
    func selectSuggestion(_ suggestion: HeroSuggestion, appointment: [Appointment]){
        //Mostra a escolha no chat
        let appointments = Appointment.mockData() // TODO: Remover
        
        for appointment in appointments {
            print(appointment.describe())
        }

        
        messages.append(MessageChat(author: .user, text: suggestion.title))
        
        //Decide o que fazer
        switch suggestion.type{
        //Ações específicas
        case .checkAvailableTimes:
            //Manda o prompt  para a IA
            answer(
                /* "Verifique os horários disponíveis hoje para agendamento com base nos horários de agendamentos cadastrados e com status confirmado. A saída de resposta informar somente os horários disponíveis"*/
                question: """
                Você é um assistente responsável por analisar horários de agendamentos.
                
                Sua tarefa é identificar os horários disponíveis no dia de hoje com base nos agendamentos já cadastrados.

                Considere que:
                - O horário de funcionamento é das 08:00 às 18:00.
                - Cada agendamento ocupa exatamente o intervalo informado.
                - Não pode haver sobreposição de horários.
                - Você deve encontrar os intervalos livres entre os agendamentos existentes.

                Instruções:
                - Analise os horários ocupados.
                - Identifique os intervalos livres entre eles.
                - Retorne apenas os horários disponíveis (intervalos livres).
                - NÃO inclua a data na resposta.
                - NÃO explique o raciocínio.

                Formato de saída (OBRIGATÓRIO):
                [
                  { "inicio": "HH:mm", "fim": "HH:mm" },
                  { "inicio": "HH:mm", "fim": "HH:mm" }
                ]

                Pergunta do usuário:
                Verifique os horários disponíveis hoje para agendamento.
                """,
                appointments: appointments.filter({ Calendar.current.isDateInToday($0.startDate)})
                
            )
        }
    }
    
    //MARK: Lógica
    private func answer(question: String, appointments: [Appointment]){
        
        loading = true
        
        Task{
            do{
                let prompt = createPrompt(question: question, appointments: appointments)
                
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
        
        let context = createContext(appointments)
        //Injeta dados do app e pergunta do user
        return """
        Agendamentos cadastrados:
        \(context)
        
        
        Pergunta: \(question)
        """
    }
    
    //MARK: transforma dados em texto
    private func createContext(_ appointments: [Appointment]) -> String{
        guard !appointments.isEmpty else{
            return "Nenhum agendamento cadastrado"
        }
        
        return appointments
            .sorted { $0.startDate < $1.startDate }
            //Transforma cada agendamento em texto para o Foundation entender
            .map { $0.describe()}
            .joined(separator: "\n\n")
    }
}
