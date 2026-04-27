//
//  OnBoardingView.swift
//  Prontu!
//
//  Created by Luciana Liebl de Freitas on 27/04/26.
//
import SwiftUI

//Dados de cada tela
private struct PageData{
    let image: String
    let title: String
    let description: String
}

private let pages: [PageData] = [
    PageData(image: "icone",
             title: "Bem-vindo ao Prontu!",
             description: "Organize seus atendimentos, gerencie seus clientes e acompanhe ses resultados, tudo em um só lugar"),
    PageData(image: "calendar.badge.checkmark",
             title: "Sua agenda organizada",
             description: "Visualize, acompanhe e organize seus atendimentos de forma simples e rápida."),
    PageData(image: "message.badge.waveform",
             title: "Seus clientes à mão",
             description: "Cadastre, busque e visualize as informações de contato dos seus clientes com facilidade."),
    PageData(image: "chart.bar.xaxis",
             title: "Acompanhe seus resultados",
             description: "Controle suas horas de atendimento e o número de clientes atendidos por semana, mês ou ano.")
]


