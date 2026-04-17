//
//  Appointment.swift
//  Challenge13
//
//  Created by Caio Mandarino on 01/04/26.
//

import SwiftData
import Foundation

@Model
final class Appointment {
    
    @Attribute(.unique)
    var id: UUID = UUID()
    
    var startDate: Date
    var endDate: Date
    var status: AppointmentStatus
    
    var client: Client? // Opcional pq caso eu crie um bloqueio o client n deve ser setado pq n tem o client para isso
    
    var exercises: String?
    var equipment: String?
    var notes: String?
    
    init(
        id: UUID = UUID(),
        startDate: Date = .now,
        endDate: Date = .now,
        status: AppointmentStatus = .pending,
        client: Client? = nil,
        exercises: String? = nil,
        equipment: String? = nil,
        notes: String? = nil
    ) { // TODO: alterar os init para tirar o valores defaults
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.status = status
        self.client = client
        self.exercises = exercises
        self.equipment = equipment
        self.notes = notes
    }
    
    func describe() -> String {
        let formatter = ISO8601DateFormatter()
        
        let start = formatter.string(from: startDate)
        let end = formatter.string(from: endDate)
        /*let clientDetails = client?.describe() ?? "Sem cliente"
        let exercisesText = exercises ?? "Não informado"
        let equipmentText = equipment ?? "Não informado"
        let notesText = notes ?? "Sem observações"
        
        - Exercícios: \(exercisesText)
        - Equipamento: \(equipmentText)
        - Observações: \(notesText)*/
        
        return """
        Agendamento:
        - Início: \(start)
        - Fim: \(end)
        - Status: \(status.rawValue)
        """
    }
}
//Extension para adicionar funcionalidades extrar ao Appointment
extension Appointment {
    //Gera um lista de agendamentos falsos para teste
    static func mockData() -> [Appointment] {
        
        let calendar = Calendar.current
        let hoje = Date()
        
        // MARK: - Clientes
        let cliente1 = Client(name: "Maria Silva", contactInfo: "11999990000", observations: "Dor lombar")
        let cliente2 = Client(name: "João Souza", contactInfo: "11988887777", observations: "Joelho")
        let cliente3 = Client(name: "Ana Costa", contactInfo: "11977776666", observations: "Cervical")
        
        //Agrupa os clientes em um Array
        let clientes = [cliente1, cliente2, cliente3]
        
        // MARK: - Helper de data
        func criarData(dia: Int, hora: Int) -> Date {
            let base = calendar.date(byAdding: .day, value: dia, to: hoje)!
            return calendar.date(bySettingHour: hora, minute: 0, second: 0, of: base)!
        }
        
        //Onde tudo está sendo armazenado
        var appointments: [Appointment] = []
        
        // MARK: - Dias (0 = hoje, 1 = amanhã...)
        for dia in 0..<5 {
            
            // Horários fixos
            let horarios = [8, 9, 10, 11, 12, 14, 15, 16, 17]
            
            for (index, hora) in horarios.enumerated() {
                
                let inicio = criarData(dia: dia, hora: hora)
                //Cada consulta dura 1h
                let fim = calendar.date(byAdding: .hour, value: 1, to: inicio)!
                
                // MARK: - Regras determinísticas
                // Horários bloqueados 12h e 17h em dias pares
                if hora == 12 || hora == 17 && dia % 2 == 0 {
                    appointments.append(
                        Appointment(
                            id: UUID(),
                            startDate: inicio,
                            endDate: fim,
                            status: .blocked,
                            client: nil,
                            exercises: nil,
                            equipment: nil,
                            notes: "Horário bloqueado"
                        )
                    )
                    continue
                }
                
                // Cliente fixo baseado no índice
                let cliente = clientes[index % clientes.count]
                
                // Status fixo baseado no horário
                let status: AppointmentStatus
                switch hora {
                case 8, 9:
                    status = .confirmed
                case 10, 11:
                    status = .pending
                case 14, 15:
                    status = .finished
                default:
                    status = .cancelled
                }
                
                appointments.append(
                    Appointment(
                        id: UUID(),
                        startDate: inicio,
                        endDate: fim,
                        status: status,
                        client: cliente,
                        exercises: "Exercício \(index + 1)",
                        equipment: "Equipamento \(index + 1)",
                        notes: "Sessão do dia \(dia) às \(hora)h"
                    )
                )
            }
        }
        
        return appointments
    }
}
