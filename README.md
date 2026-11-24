# Prontu!

App de iPhone com agenda e clientes para profissionais que atendem em vários lugares. Funciona sem internet e tem um assistente que responde sobre a agenda em linguagem natural, direto no aparelho.

App na App Store · Projeto da Apple Developer Academy (Challenge 13) · iOS 26+ · 2026

[Prontu! na App Store](https://apps.apple.com/br/app/prontu/id6764180094) · [Prontu! no portfólio](https://cauecarneiro.github.io/portfolio/)

## O que faz

- **Agenda:** faixa semanal de calendário e linha do tempo do dia, com criação, edição e status dos atendimentos.
- **Clientes:** lista com índice alfabético, cadastro, edição e histórico de sessões de cada cliente; importa contatos do iPhone.
- **Sugestão de equipamentos:** um modelo de Core ML sugere os equipamentos de cada atendimento.
- **Assistente da agenda:** chat que entende perguntas sobre os atendimentos e responde com o modelo de linguagem do próprio aparelho (Foundation Models).
- **Relatórios:** métricas e gráficos dos atendimentos, em Swift Charts.
- **Privacidade:** os dados ficam no iPhone, com bloqueio por Face ID ou Touch ID, e o app tem onboarding com termos de uso e política de privacidade.

## Meu papel

Projeto de time de 5 pessoas na Apple Developer Academy. Eu criei o repositório (commit inicial de 01/04/2026), revisei e mesclei parte dos pull requests (10 dos 36) e publiquei o app na minha conta de desenvolvedor.

No código, a minha parte, pelos 22 commits e pelos 8 pull requests que abri, foi:

- importação de contatos do iPhone (`ContactPickerView`);
- telas de criar e editar cliente (`CreateClient`, `EditClient`);
- tela de relatórios (`AppointmentReport`);
- onboarding com barra de progresso, consentimento e Face ID (`OnBoarding`);
- correções depois do lançamento, como o botão de excluir cliente.

O restante do app (navegação, banco de dados, agenda, assistente e modelo de equipamentos) foi escrito pelas outras pessoas do time.

## Como foi feito

- **MVVM-C:** cada fluxo tem Coordinator, Router e Factory (`Screens/AgendaFlow/Core`, `Screens/RegisterFlow/Core`, `Screens/AppointmentReportFlow/Core`) e cada tela tem uma ViewModel.
- **Navegação própria:** `Helpers/Navigation` concentra o `NavigationController` e a navegação por sheets.
- **Dados com SwiftData:** modelos em `Entity/` (`Appointment`, `Client`) e acesso por `Services/DatabaseService.swift`.
- **IA no aparelho:** `Services/Chatbot` classifica a intenção da pergunta com Foundation Models e o `AppointmentChatEngine` monta a resposta; `Services/MLModel` usa um classificador tabular de Core ML para sugerir equipamentos.
- **Sem números soltos na interface:** as regras do projeto (`AGENTS.md`) mandam centralizar medidas e cores em `Helpers/GlobalConfiguration.swift`.

## Tecnologias

Swift, SwiftUI, SwiftData, MVVM-C com Coordinators, Foundation Models, Core ML, Swift Charts, Contacts, LocalAuthentication.

## Como rodar

1. Abra `Challenge13/Prontu!.xcodeproj` no Xcode (o projeto usa SDK do iOS 26 ou mais novo, e o Assistente exige um aparelho com Apple Intelligence).
2. Escolha um simulador ou iPhone e rode (Cmd+R).
3. Para rodar no aparelho, escolha a sua equipe em Signing & Capabilities.

Não há chaves nem serviços externos: o app funciona offline.

## Licença

[MIT](LICENSE).

---
Feito por Cauê Crillanovick · [portfólio](https://cauecarneiro.github.io/portfolio/) · [LinkedIn](https://www.linkedin.com/in/cau%C3%AA-carneiro)
