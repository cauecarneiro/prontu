//
//  PrivacyPolicyView.swift
//  Prontu!
//
//  Created by Caio Mandarino on 28/04/26.
//
import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: GlobalConfiguration.normalSpacing) {
                    Text("POLÍTICA DE PRIVACIDADE")
                        .font(.title)
                        .bold()
                    
                    Text("Este Aviso de Privacidade descreve como e por que podemos acessar, coletar, armazenar, usar e/ou compartilhar (\"processar\") informações pessoais quando você utiliza nossos serviços.")
                    
                    Text("Ler este Aviso de Privacidade ajudará você a entender seus direitos e escolhas de privacidade. Somos responsáveis por tomar decisões sobre como suas informações pessoais são processadas. Se você não concorda com nossas políticas e práticas, por favor, não utilize nossos Serviços.")
                    
                    sectionTitle("PERGUNTAS FREQUENTES")
                    
                    question(
                        title: "Quais informações pessoais nós processamos?",
                        text: "Quando você visita, usa ou navega em nossos Serviços, podemos processar informações pessoais dependendo de como você interage conosco e com os Serviços, das escolhas que você faz e dos produtos e recursos que utiliza. Saiba mais sobre as informações pessoais que você nos fornece abaixo."
                    )
                    
                    question(
                        title: "Processamos informações pessoais sensíveis?",
                        text: "Algumas informações podem ser consideradas \"especiais\" ou \"sensíveis\" em certas jurisdições, como, por exemplo, dados de saúde."
                    )
                    
                    question(
                        title: "Como processamos suas informações?",
                        text: "Processamos informações para fornecer, melhorar e administrar nossos Serviços, para fins de segurança e prevenção de fraudes e para cumprir a lei. Também podemos processar dados para outros fins mediante seu consentimento."
                    )
                    
                    sectionTitle("1. QUAIS INFORMAÇÕES NÓS COLETAMOS?")
                    
                    Text("Em resumo: Coletamos informações pessoais que você nos fornece diretamente.")
                        .bold()
                    
                    Text("Nós coletamos informações pessoais que você fornece voluntariamente ao usar nossos Serviços, ao expressar interesse em obter informações sobre nós ou sobre nossos produtos e Serviços, ao participar de atividades nos Serviços ou, de outra forma, ao entrar em contato conosco.")
                    
                    Text("Todas as informações pessoais fornecidas por você devem ser verdadeiras, completas e precisas, e você precisa coletar a autorização dos seus pacientes para registrar e armazenar informações pessoais e de saúde em nosso aplicativo.")
                    
                    sectionTitle("2. COMO PROCESSAMOS SUAS INFORMAÇÕES?")
                    
                    Text("Processamos informações para fornecer, melhorar e administrar nossos Serviços, nos comunicar com você, para fins de segurança e prevenção de fraudes e para cumprir a lei. Também podemos processar seus dados para outros fins mediante seu consentimento.")
                    
                    Text("Nós processamos informações pessoais para implementação de sugestões automáticas a partir do Foundation Models (IA on-device da Apple) e para armazenar o histórico de atendimentos por paciente.")
                    
                    sectionTitle("3. QUANDO E COM QUEM COMPARTILHAMOS SUAS INFORMAÇÕES PESSOAIS?")
                    
                    Text("Não compartilhamos informações pessoais com terceiros.")
                        .bold()
                    
                    sectionTitle("4. SUAS INFORMAÇÕES SÃO TRANSFERIDAS INTERNACIONALMENTE?")
                    
                    Text("As informações podem ser processadas, armazenadas e usadas fora do país em que você está localizado. As leis de privacidade de dados variam entre as jurisdições, e diferentes leis podem ser aplicáveis aos seus dados, dependendo de onde eles são processados, armazenados ou usados.")
                    
                    sectionTitle("5. POR QUANTO TEMPO MANTEMOS SUAS INFORMAÇÕES?")
                    
                    Text("A exclusão dos dados pode ser realizada a qualquer momento pelo fisioterapeuta. As informações ficarão armazenadas enquanto o fisioterapeuta não realizar a exclusão. A exclusão será possível a partir da solicitação da exclusão pelo paciente ao fisioterapeuta. Após a exclusão dos dados, não é possível acessá-los novamente.")
                    
                    sectionTitle("6. COLETAMOS INFORMAÇÕES DE MENORES DE IDADE?")
                    
                    Text("Não coletamos intencionalmente dados de crianças menores de 18 anos, nem fazemos marketing para elas. Entretanto, caso o fisioterapeuta/usuário inclua dados de menores de idade, o fisioterapeuta/usuário se compromete a pedir a autorização dos responsáveis para registrar e armazenar os dados no aplicativo.")
                    
                    sectionTitle("7. QUAIS SÃO OS SEUS DIREITOS DE PRIVACIDADE?")
                    
                    Text("Você pode revisar, alterar ou encerrar sua conta a qualquer momento.")
                    
                    Text("O paciente tem o direito de revogar o consentimento para uso dos seus dados a qualquer momento. A partir da solicitação do paciente, o fisioterapeuta/usuário fica obrigado a excluir os dados do paciente no aplicativo. No entanto, observe que isso não afetará a legalidade do processamento realizado antes da revogação.")
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button("Fechar", systemImage: "xmark") {
                        dismiss()
                    }
                    .frame(maxWidth: 30)
                }
            }
        }
    }
    
    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(.title3)
            .fontWeight(.semibold)
    }
    
    @ViewBuilder
    private func question(title: String, text: String) -> some View {
        Text(title)
            .font(.headline)
        
        Text(text)
    }
}

#Preview("Privacy Policy") {
    PrivacyPolicyView()
}
