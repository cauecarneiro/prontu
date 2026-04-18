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
    
    var client: Client?
    
    var exercises: String?
    var equipment: String?
    var notes: String?
    
    init(
        id: UUID = UUID(),
        startDate: Date,
        endDate: Date,
        status: AppointmentStatus = .scheduled,
        client: Client? = nil,
        exercises: String? = nil,
        equipment: String? = nil,
        notes: String? = nil
    ) {
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
        
        return """
        Agendamento:
        - Início: \(start)
        - Fim: \(end)
        - Status: \(status.rawValue)
        """
    }
}

import Foundation

private struct SeededGenerator: RandomNumberGenerator {
    private var state: UInt64
    
    init(seed: UInt64) {
        self.state = seed == 0 ? 0x123456789ABCDEF : seed
    }
    
    mutating func next() -> UInt64 {
        state &+= 0x9E3779B97F4A7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58476D1CE4E5B9
        z = (z ^ (z >> 27)) &* 0x94D049BB133111EB
        return z ^ (z >> 31)
    }
}

private extension Array {
    func randomElement<T: RandomNumberGenerator>(using generator: inout T) -> Element {
        self[Int.random(in: 0..<count, using: &generator)]
    }
    
    func shuffled<T: RandomNumberGenerator>(using generator: inout T) -> [Element] {
        var copy = self
        copy.shuffle(using: &generator)
        return copy
    }
}

extension Appointment {
    static func mockData() -> [Appointment] {
        var rng = SeededGenerator(seed: 20260418)
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        // MARK: - Catálogo
        let objectives = [
            "fortalecimento",
            "flexibilidade",
            "propriocepção",
            "mobilidade",
            "coordenação motora"
        ]
        
        let allExercises = [
            "Agachamento com carga",
            "Extensão de perna",
            "Afundo",
            "Elevação lateral",
            "Desenvolvimento",
            "Rotação externa",
            "Abdominal infra com carga",
            "Prancha com peso",
            "Elevação de calcanhar sentado",
            "Plantiflexão unilateral",
            "Aperto de mão resistido",
            "Flexão de dedos",
            "Alongamento gato-camelo",
            "Prece",
            "Alongamento de gastrocnêmio",
            "Alongamento de sóleo",
            "Alongamento de peitoral no batente",
            "Alongamento de cápsula posterior",
            "Equilíbrio unipodal dinâmico",
            "Estabilização de salto",
            "Agachamento em superfície instável",
            "Apoio unipodal",
            "Mobilidade 90-90",
            "Círculos de quadril",
            "Rotação torácica",
            "Extensão torácica",
            "Deslocamento em zig-zag",
            "Saltos laterais",
            "Transferência de objetos",
            "Pinça digital"
        ]
        
        let regions = [
            "joelho",
            "ombro",
            "core (abdominal)",
            "panturrilha",
            "mão/dedos",
            "lombar",
            "tornozelo",
            "quadril",
            "coluna",
            "global"
        ]
        
        // MARK: - Exercícios por região
        let exercisesByRegion: [String: [String]] = [
            "joelho": [
                "Agachamento com carga",
                "Extensão de perna",
                "Afundo",
                "Equilíbrio unipodal dinâmico",
                "Agachamento em superfície instável",
                "Apoio unipodal",
                "Deslocamento em zig-zag",
                "Saltos laterais"
            ],
            "ombro": [
                "Elevação lateral",
                "Desenvolvimento",
                "Rotação externa",
                "Alongamento de peitoral no batente",
                "Alongamento de cápsula posterior"
            ],
            "core (abdominal)": [
                "Abdominal infra com carga",
                "Prancha com peso",
                "Alongamento gato-camelo",
                "Rotação torácica",
                "Extensão torácica"
            ],
            "panturrilha": [
                "Elevação de calcanhar sentado",
                "Plantiflexão unilateral",
                "Alongamento de gastrocnêmio",
                "Alongamento de sóleo",
                "Estabilização de salto"
            ],
            "mão/dedos": [
                "Aperto de mão resistido",
                "Flexão de dedos",
                "Transferência de objetos",
                "Pinça digital"
            ],
            "lombar": [
                "Alongamento gato-camelo",
                "Prancha com peso",
                "Mobilidade 90-90",
                "Rotação torácica",
                "Extensão torácica"
            ],
            "tornozelo": [
                "Plantiflexão unilateral",
                "Equilíbrio unipodal dinâmico",
                "Estabilização de salto",
                "Apoio unipodal",
                "Saltos laterais"
            ],
            "quadril": [
                "Afundo",
                "Mobilidade 90-90",
                "Círculos de quadril",
                "Agachamento com carga",
                "Agachamento em superfície instável"
            ],
            "coluna": [
                "Alongamento gato-camelo",
                "Rotação torácica",
                "Extensão torácica",
                "Mobilidade 90-90",
                "Prece"
            ],
            "global": allExercises
        ]
        
        // MARK: - Objetivos por região
        let objectivesByRegion: [String: [String]] = [
            "joelho": ["fortalecimento", "propriocepção", "coordenação motora", "mobilidade"],
            "ombro": ["fortalecimento", "flexibilidade", "mobilidade"],
            "core (abdominal)": ["fortalecimento", "mobilidade"],
            "panturrilha": ["fortalecimento", "flexibilidade", "propriocepção"],
            "mão/dedos": ["coordenação motora", "fortalecimento", "mobilidade"],
            "lombar": ["mobilidade", "fortalecimento", "flexibilidade"],
            "tornozelo": ["propriocepção", "coordenação motora", "fortalecimento", "mobilidade"],
            "quadril": ["mobilidade", "fortalecimento", "flexibilidade"],
            "coluna": ["mobilidade", "flexibilidade", "fortalecimento"],
            "global": objectives
        ]
        
        // MARK: - Equipamentos por exercício
        let equipmentByExercise: [String: String] = [
            "Agachamento com carga": "Barra / halter",
            "Extensão de perna": "Caneleira",
            "Afundo": "Halter",
            "Elevação lateral": "Halter",
            "Desenvolvimento": "Halter",
            "Rotação externa": "Faixa elástica",
            "Abdominal infra com carga": "Peso livre",
            "Prancha com peso": "Anilha",
            "Elevação de calcanhar sentado": "Peso livre",
            "Plantiflexão unilateral": "Peso corporal",
            "Aperto de mão resistido": "Hand grip",
            "Flexão de dedos": "Faixa elástica",
            "Alongamento gato-camelo": "Colchonete",
            "Prece": "Colchonete",
            "Alongamento de gastrocnêmio": "Parede / apoio",
            "Alongamento de sóleo": "Parede / apoio",
            "Alongamento de peitoral no batente": "Batente",
            "Alongamento de cápsula posterior": "Sem equipamento",
            "Equilíbrio unipodal dinâmico": "Bosu",
            "Estabilização de salto": "Step",
            "Agachamento em superfície instável": "Bosu",
            "Apoio unipodal": "Sem equipamento",
            "Mobilidade 90-90": "Colchonete",
            "Círculos de quadril": "Sem equipamento",
            "Rotação torácica": "Colchonete",
            "Extensão torácica": "Rolo",
            "Deslocamento em zig-zag": "Cones",
            "Saltos laterais": "Cones",
            "Transferência de objetos": "Blocos",
            "Pinça digital": "Prendedores"
        ]
        
        // MARK: - Clientes base
        let clientNames = [
            "Maria Silva",
            "João Souza",
            "Ana Costa",
            "Carlos Lima",
            "Fernanda Alves",
            "Paulo Mendes",
            "Juliana Rocha",
            "Ricardo Nunes",
            "Patrícia Gomes",
            "Bruno Martins",
            "Camila Ferreira",
            "Lucas Almeida"
        ]
        
        let contacts = [
            "11999990000",
            "11988887777",
            "11977776666",
            "11966665555",
            "11955554444",
            "11944443333",
            "11933332222",
            "11922221111",
            "11911110000",
            "11912344321",
            "11987654321",
            "11991234567"
        ]
        
        let clientProfiles: [Client] = zip(clientNames, contacts).enumerated().map { index, pair in
            let region = regions[index % regions.count]
            return Client(
                name: pair.0,
                contactInfo: pair.1,
                observations: "Foco em \(region)"
            )
        }
        
        // MARK: - Helpers
        func makeDate(dayOffset: Int, hour: Int, minute: Int = 0) -> Date {
            let base = calendar.date(byAdding: .day, value: dayOffset, to: today)!
            return calendar.date(bySettingHour: hour, minute: minute, second: 0, of: base)!
        }
        
        func status(for dayOffset: Int, using generator: inout SeededGenerator) -> AppointmentStatus {
            let draw = Int.random(in: 0..<100, using: &generator)
            
            if dayOffset < 0 {
                switch draw {
                case 0..<75: return .finished
                case 75..<90: return .cancelled
                default: return .confirmed
                }
            } else if dayOffset == 0 {
                switch draw {
                case 0..<50: return .confirmed
                case 50..<85: return .scheduled
                case 85..<95: return .finished
                default: return .cancelled
                }
            } else {
                switch draw {
                case 0..<55: return .scheduled
                case 55..<90: return .confirmed
                case 90..<97: return .cancelled
                default: return .finished
                }
            }
        }
        
        func region(from client: Client) -> String {
            regions.first(where: { client.observations?.localizedCaseInsensitiveContains($0) ?? false }) ?? "global"
        }
        
        func makeTherapyData(for region: String, using generator: inout SeededGenerator) -> (objective: String, exercises: [String], equipment: String) {
            let possibleObjectives = objectivesByRegion[region] ?? objectives
            let possibleExercises = exercisesByRegion[region] ?? allExercises
            
            let objective = possibleObjectives.randomElement(using: &generator)
            
            let selectedExercises = Array(possibleExercises.shuffled(using: &generator).prefix(Int.random(in: 2...3, using: &generator)))
            
            let equipments = selectedExercises.compactMap { equipmentByExercise[$0] }
            let equipmentSummary = Array(Set(equipments)).joined(separator: ", ")
            
            return (objective, selectedExercises, equipmentSummary.isEmpty ? "Sem equipamento" : equipmentSummary)
        }
        
        func shouldBlock(hour: Int, weekday: Int, using generator: inout SeededGenerator) -> Bool {
            if hour == 12 { return true } // almoço
            
            if weekday == 7 && hour == 11 {
                return Bool.random(using: &generator)
            }
            
            return Int.random(in: 0..<100, using: &generator) < 10
        }
        
        // MARK: - Geração
        var appointments: [Appointment] = []

        // 30 dias centrados em hoje: 10 passados + hoje + 19 futuros
        for dayOffset in -10..<20 {
            let currentDate = calendar.date(byAdding: .day, value: dayOffset, to: today)!
            let weekday = calendar.component(.weekday, from: currentDate)

            // domingo sem atendimento
            if weekday == 1 { continue }

            let slots: [DateInterval] = {
                if weekday == 7 {
                    // sábado
                    return [
                        DateInterval(start: makeDate(dayOffset: dayOffset, hour: 8), end: makeDate(dayOffset: dayOffset, hour: 9)),
                        DateInterval(start: makeDate(dayOffset: dayOffset, hour: 9), end: makeDate(dayOffset: dayOffset, hour: 10)),
                        DateInterval(start: makeDate(dayOffset: dayOffset, hour: 10), end: makeDate(dayOffset: dayOffset, hour: 11)),
                        DateInterval(start: makeDate(dayOffset: dayOffset, hour: 11), end: makeDate(dayOffset: dayOffset, hour: 12))
                    ]
                } else {
                    // dias úteis
                    return [
                        DateInterval(start: makeDate(dayOffset: dayOffset, hour: 8), end: makeDate(dayOffset: dayOffset, hour: 9)),
                        DateInterval(start: makeDate(dayOffset: dayOffset, hour: 9), end: makeDate(dayOffset: dayOffset, hour: 10)),
                        DateInterval(start: makeDate(dayOffset: dayOffset, hour: 10), end: makeDate(dayOffset: dayOffset, hour: 11)),
                        DateInterval(start: makeDate(dayOffset: dayOffset, hour: 11), end: makeDate(dayOffset: dayOffset, hour: 12)),
                        DateInterval(start: makeDate(dayOffset: dayOffset, hour: 12), end: makeDate(dayOffset: dayOffset, hour: 14)), // almoço
                        DateInterval(start: makeDate(dayOffset: dayOffset, hour: 14), end: makeDate(dayOffset: dayOffset, hour: 15)),
                        DateInterval(start: makeDate(dayOffset: dayOffset, hour: 15), end: makeDate(dayOffset: dayOffset, hour: 16)),
                        DateInterval(start: makeDate(dayOffset: dayOffset, hour: 16), end: makeDate(dayOffset: dayOffset, hour: 17)),
                        DateInterval(start: makeDate(dayOffset: dayOffset, hour: 17), end: makeDate(dayOffset: dayOffset, hour: 18))
                    ]
                }
            }()

            for slot in slots {
                let hour = calendar.component(.hour, from: slot.start)
                let slotDuration = Int(slot.end.timeIntervalSince(slot.start) / 60)

                let allowedDurations = [50, 60, 90].filter { $0 <= slotDuration }
                let duration = allowedDurations.randomElement(using: &rng) ?? slotDuration
                let endDate = calendar.date(byAdding: .minute, value: duration, to: slot.start)!

                if shouldBlock(hour: hour, weekday: weekday, using: &rng) {
                    appointments.append(
                        Appointment(
                            id: UUID(),
                            startDate: slot.start,
                            endDate: slot.end,
                            status: .blocked,
                            client: nil,
                            exercises: nil,
                            equipment: nil,
                            notes: "Horário bloqueado para organização interna"
                        )
                    )
                    continue
                }

                let client = clientProfiles.randomElement(using: &rng)
                let region = region(from: client)
                let therapy = makeTherapyData(for: region, using: &rng)
                let appointmentStatus = status(for: dayOffset, using: &rng)

                let notes = """
                Sessão com foco em \(therapy.objective) para \(region). \
                Conduta planejada de acordo com evolução funcional do paciente.
                """

                appointments.append(
                    Appointment(
                        id: UUID(),
                        startDate: slot.start,
                        endDate: endDate,
                        status: appointmentStatus,
                        client: client,
                        exercises: therapy.exercises.joined(separator: " • "),
                        equipment: therapy.equipment,
                        notes: notes
                    )
                )
            }
        }

        return appointments.sorted { $0.startDate < $1.startDate }
    }
}
