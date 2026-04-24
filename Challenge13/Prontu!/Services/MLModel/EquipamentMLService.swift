//
//  MLservice.swift
//  TestModelClassificationEquipament
//
//  Created by Linda Marie Ribeiro Alves Correa dos Santos on 13/04/26.
//
import CoreML

final class EquipamentMLService {

    static let shared = EquipamentMLService()

    private let model: TabularClassifierEquipament?

    private init() {
        self.model = try? TabularClassifierEquipament(
            configuration: MLModelConfiguration()
        )
    }

    func predict(input: ExerciseInput) -> String {
        guard let model else {
            return EquipamentMLServiceError.errorCreateModel
        }
        
        do {
            let prediction = try model.prediction(
                objetivo: input.objetivo,
                exercicio: input.exercicio,
                regiao: input.regiao
            )
            return prediction.equipamento

        } catch {
            return EquipamentMLServiceError.errorPrediction
        }
    }
    
    enum EquipamentMLServiceError: Error {
        static let errorCreateModel = "Erro ao carregar modelo"
        static let errorPrediction = "Erro na predição"
    }
    
    struct ExerciseInput {
        let objetivo: String
        let exercicio: String
        let regiao: String
    }
}


