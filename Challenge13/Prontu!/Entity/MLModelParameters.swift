//
//  ModelParametros.swift
//  TestModelClassificationEquipament
//
//  Created by Linda Marie Ribeiro Alves Correa dos Santos on 13/04/26.
//

import Foundation

// MARK: - Input do modelo
struct ExerciseInput {
    let objetivo: String
    let exercicio: String
    let regiao: String
}

// MARK: - Fonte de dados do dataset
final class DatasetService {

    static let shared = DatasetService()

    let objetivos: [String]
    let exercicios: [String]
    let regioes: [String]

    private init() {
        let dataset = Self.readBundle()
        objetivos  = dataset.objetivos
        exercicios = dataset.exercicios
        regioes    = dataset.regioes
    }
    
    private static func readBundle() -> EquipmentDataset {
        guard
            let url = Bundle.main.url(
                forResource: GlobalConfiguration.dataFileName,
                withExtension: GlobalConfiguration.fileExtension
            ),
            let data = try? Data(contentsOf: url),
            let dataset = try? JSONDecoder().decode(EquipmentDataset.self, from: data)
        else {
            print("Arquivo \(GlobalConfiguration.dataFileName).\(GlobalConfiguration.fileExtension) não encontrado ou inválido no bundle.")
            return .init(objetivos: [], exercicios: [], regioes: [])
        }
        return dataset
    }
    
    private struct EquipmentDataset: Decodable {
        let objetivos: [String]
        let exercicios: [String]
        let regioes: [String]
    }
}
