//
//  DatabaseService.swift
//  Challenge13
//
//  Created by Caio Mandarino on 08/04/26.
//


import Foundation
import SwiftData
import Combine

@MainActor
final class DatabaseService {
    
    private let databaseChange: PassthroughSubject<Void, Never> = .init()
    private let context: ModelContext
    
    public var databaseChangePublisher: AnyPublisher<Void, Never> {
        databaseChange.eraseToAnyPublisher()
    }
    
    init(context: ModelContext) {
        self.context = context
    }
    
    /**
     Adiciona e salva no banco de dados
     */
    func add<T: PersistentModel>(element: T) {
        context.insert(element)
        saveContext()
    }
    
    /**
     Deleta do banco de dados
     */
    func delete<T: PersistentModel>(element: T) {
        context.delete(element)
        saveContext()
    }
    
    /**
     Atualiza um elemento do banco de dados
     */
    func update<T: PersistentModel>(element: T) {
        saveContext()
    }
    
    /**
     Retorna todos os elementos do banco de dados com base em um predicate e sortBy
     */
    func getAllElements<T: PersistentModel>(predicate: Predicate<T>? = nil, sortBy: [SortDescriptor<T>] = []) -> [T] {
        do {
            let fetchDescriptor = FetchDescriptor(predicate: predicate, sortBy: sortBy)
            let elements = try context.fetch(fetchDescriptor)
            return elements
        } catch {
            print("Error ao buscar os dados: \(error)")
            return []
        }
    }
    
    private func saveContext() {
        do {
            try context.save()
            databaseChange.send()
        } catch {
            print("Erro ao salvar o contexto: \(error)")
        }
    }
    
}

extension DatabaseService: AppointmentProviding {
    func fetchAppointments(from start: Date, to end: Date) -> [Appointment] {
        let predicate = #Predicate<Appointment> { appointment in
            appointment.startDate >= start && appointment.startDate < end
        }
        
        return getAllElements(predicate: predicate)
    }
    
    func fetchOverlappingAppointments(from start: Date, to end: Date) -> [Appointment] {
        let predicate = #Predicate<Appointment> { appointment in
            appointment.startDate < end && appointment.endDate > start
        }
        
        return getAllElements(predicate: predicate)
    }
}
