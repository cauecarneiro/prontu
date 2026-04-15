---
paths:
  - "Challenge13/Challenge13/Screens/**/*.swift"
  - "Challenge13/Challenge13/Helpers/Navigation/**/*.swift"
---

# Arquitetura MVVM-C — Flows e Navegação

Projeto SwiftUI em **MVVM-C**. Toda tela nova pertence a um **Flow** e segue estritamente o padrão **Coordinator + Factory + Router**. O core de navegação em `Helpers/Navigation/` é incrementável, **nunca removível ou reescrito** — adicione capacidades sem alterar assinaturas existentes.

## Estrutura obrigatória de um Flow

```
Screens/<Nome>Flow/
├── Core/
│   ├── <Nome>FlowCoordinator.swift   # final class : Coordinator
│   ├── <Nome>FlowFactory.swift       # final class, VMs como `lazy var`
│   └── <Nome>FlowRouter.swift        # enum com rotas do flow
└── <Tela>/
    ├── <Tela>View.swift
    ├── <Tela>ViewModel.swift
    ├── <Tela>CoordinatorProtocol.swift  # contrato View→Coordinator
    └── Components/                       # opcional, subviews exclusivas da tela
```

## Regras do Coordinator

- `final class <Nome>FlowCoordinator: Coordinator` com `navigationController: NavigationController = .init()`.
- Factory injetada no init; após `self.factory = factory`, **sempre** setar `self.factory.coordinator = self`.
- `rootView` e `coordinate(to:)` marcados com `@MainActor @ViewBuilder`.
- `coordinate(to:)` faz `switch` **exaustivo** sobre o `Router` do flow — sem `default`.
- Helpers `navigateTo`, `presentTo`, `dismissNavigation`, `dismissPresentation` ficam **privados** e delegam a `navigationController`.
- Conformidade a `<Tela>CoordinateProtocol` é declarada em `extension` separada por tela.

## Regras do Factory

- `final class <Nome>FlowFactory` com Services via init e `weak var coordinator: <Nome>FlowCoordinator?`.
- ViewModels guardados como `private lazy var <tela>VM: <Tela>ViewModel = ...` (uma VM viva por flow, não recriada por push).
- Um método `make<Tela>View()` por tela, retornando a View concreta com a VM injetada.

## Regras do Router

- `enum <Nome>FlowRouter` com um `case` por destino. Dados da tela destino viajam como **associated values** (ex: `case appointmentDetails(Appointment)`).
- Nunca passe dados via singleton/UserDefaults para comunicar entre telas do mesmo flow.

## Regras da View/ViewModel

- View recebe `viewModel` via init; ViewModel recebe `coordinator: <Tela>CoordinateProtocol?` (protocolo, nunca a classe concreta).
- View **não** chama `navigationController` diretamente — apenas `viewModel.<ação>()` que chama `coordinator?.navigateTo<Destino>(...)`.
- `<Tela>CoordinatorProtocol.swift` define apenas os métodos de navegação que aquela tela dispara.

## Core de Navegação (`Helpers/Navigation/`)

- **Incremental-only**: pode adicionar novos modificadores, tipos de sheet, extensões. **Não remover nem quebrar** `Coordinator`, `NavigationController`, `CoordinateView`, `NavigationFactory`, `SheetModifier`, `SheetPath`, `SheetFactoryKey`.
- Novas capacidades de navegação devem ser adicionadas como extensões ou novos tipos, preservando APIs existentes.
