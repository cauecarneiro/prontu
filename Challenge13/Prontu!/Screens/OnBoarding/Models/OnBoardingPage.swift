//
//  OnBoardingPage.swift
//  Prontu!
//
//  Created by Luciana Liebl de Freitas on 27/04/26.
//
import Foundation

struct OnBoardingPage {
    let image: String
    let title: String
    let description: String
}

extension OnBoardingPage {
    
    static let mock: [OnBoardingPage] = [
        OnBoardingPage(
            image: "icon",
            title: "Bem-vindo ao Prontu!",
            description: "Organize seus atendimentos, gerencie seus clientes e acompanhe seus resultados, tudo em um só lugar"
        ),
        OnBoardingPage(
            image: "Calendar",
            title: "Sua agenda organizada",
            description: "Visualize, acompanhe e organize seus atendimentos de forma simples e rápida."
        ),
        OnBoardingPage(
            image: "Clients",
            title: "Seus clientes à mão",
            description: "Cadastre, busque e visualize as informações de contato dos seus clientes com facilidade."
        ),
        OnBoardingPage(
            image: "Charts",
            title: "Acompanhe seus resultados",
            description: "Controle suas horas de atendimento e o número de clientes atendidos por semana, mês ou ano."
        )
    ]
}
