//
//  TermsOfUseView.swift
//  Prontu!
//
//  Created by Codex on 28/04/26.
//
import SwiftUI

struct TermsOfUseView: View {
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: GlobalConfiguration.normalSpacing) {
                Text("TERMOS E CONDIÇÕES DE USO - PRONTU!")
                    .font(.title)
                    .bold()
                
                Text("Última atualização: 28 de abril de 2026")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Group {
                    Text("Estes Termos Legais constituem um acordo juridicamente vinculante celebrado entre você (doravante \"Usuário\"), seja pessoalmente ou em nome de uma entidade, e o Prontu!, relacionado ao seu acesso e uso dos Serviços.")
                    
                    Text("Ao acessar os Serviços, você confirma que leu, compreendeu e concordou em ficar vinculado a estes Termos. SE VOCÊ NÃO CONCORDAR, ESTÁ EXPRESSAMENTE PROIBIDO DE USAR OS SERVIÇOS.")
                        .bold()
                }
                
                sectionTitle("1. NATUREZA DOS SERVIÇOS E LGPD")
                
                Text("O Prontu! opera como uma ferramenta de produtividade para o usuário.")
                
                bullet(
                    title: "Responsabilidade de Dados (Controlador): ",
                    text: "Nos termos da Lei Geral de Proteção de Dados (Lei nº 13.709/2018 - LGPD), o Usuário é o único Controlador dos dados inseridos (nome, contato, histórico de saúde)."
                )
                
                bullet(
                    title: "Autorização Expressa: ",
                    text: "O Usuário é o único responsável por adquirir a autorização expressa, livre e informada de seus pacientes/clientes antes de inserir qualquer dado na plataforma. O Prontu! isenta-se de qualquer responsabilidade pela falta de base legal ou consentimento na coleta desses dados."
                )
                
                bullet(
                    title: "Finalidade: ",
                    text: "As informações fornecidas não se destinam à distribuição em jurisdições onde tal uso seja contrário à lei."
                )
                
                sectionTitle("2. DIREITOS DE PROPRIEDADE INTELECTUAL E SUBMISSÕES")
                
                Text("Somos proprietários ou licenciados de todos os direitos de propriedade intelectual sobre nossos Serviços (código-fonte, funcionalidades, IA local e Marcas).")
                
                bullet(
                    title: "Suas Submissões: ",
                    text: "Antes de adicionar pacientes e conteúdos, você deve registrar formalmente a permissão de uso. Você é o único responsável por suas Submissões e concorda em nos indenizar por perdas decorrentes de:"
                )
                
                numbered("1.", "Violação de direitos de terceiros (ex.: privacidade do paciente);")
                numbered("2.", "Violação de leis aplicáveis (ex.: LGPD ou sigilo profissional);")
                numbered("3.", "Uso indevido dos campos de texto para armazenamento de dados sensíveis sem a devida cautela.")
                
                sectionTitle("3. SEGURANÇA E INTELIGÊNCIA ARTIFICIAL (IA ON-DEVICE)")
                
                Text("O Prontu! utiliza tecnologia de ponta para garantir a privacidade, operando sob o conceito de Privacy by Design:")
                
                bullet(
                    title: "Processamento Local: ",
                    text: "O histórico de atendimentos e relatórios gerados via Foundations Model são processados exclusivamente de forma local no dispositivo do Usuário. Nenhum dado de paciente é enviado para servidores externos para treinamento de IA."
                )
                
                bullet(
                    title: "Acesso Biométrico: ",
                    text: "Para proteger as informações salvas, o app solicita obrigatoriamente a autenticação via Face ID/Biometria do dispositivo. O Usuário é responsável por manter essa trava ativa e não compartilhar o acesso ao seu dispositivo."
                )
                
                sectionTitle("4. DECLARAÇÕES E ATIVIDADES PROIBIDAS")
                
                Text("Ao utilizar os Serviços, você declara que:")
                
                numbered("1.", "Possui capacidade legal e profissional (ex.: registro no conselho de classe como CREFITO) para realizar os atendimentos registrados.")
                numbered("2.", "Não utilizará os Serviços para qualquer finalidade ilegal.")
                numbered("3.", "Não tentará realizar engenharia reversa no software ou contornar as medidas de segurança.")
                
                sectionTitle("5. DISPOSITIVOS APPLE")
                
                Text("Ao utilizar o Aplicativo via App Store:")
                
                bullet(text: "A licença é intransferível e limitada ao uso de acordo com as regras das Distribuidoras.")
                bullet(text: "O Usuário reconhece que as Distribuidoras não possuem obrigação de suporte técnico, sendo esta responsabilidade exclusiva do Prontu!.")
                bullet(text: "O Usuário declara não estar em países sob embargo ou listas de restrição internacional.")
                
                sectionTitle("6. INDENIZAÇÃO E LIMITAÇÃO DE RESPONSABILIDADE")
                
                Text("O Prontu! não será responsável por:")
                
                bullet(text: "Decisões clínicas ou diagnósticos baseados nos relatórios gerados pela IA.")
                bullet(text: "Perda de dados decorrente de danos no hardware do Usuário (visto que o processamento é local).")
                bullet(text: "Acesso não autorizado por terceiros caso o Usuário não utilize as travas de segurança do dispositivo.")
                bullet(text: "Cumprimento de prazos de guarda de prontuário exigidos por lei (o app é uma ferramenta de apoio, não um arquivo público de saúde).")
                
                sectionTitle("7. DISPOSIÇÕES GERAIS")
                
                Text("Estes termos são regidos pelas leis da República Federativa do Brasil.")
            }
            .padding()
        }
    }
    
    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(.title2)
            .fontWeight(.semibold)
    }
    
    private func bullet(title: String? = nil, text: String) -> some View {
        Text("• ")
            .bold()
        + Text(title ?? "")
            .bold()
        + Text(text)
    }
    
    private func numbered(_ number: String, _ text: String) -> some View {
        Text(number + " ")
            .bold()
        + Text(text)
    }
}

#Preview("Terms of Use") {
    TermsOfUseView()
}
