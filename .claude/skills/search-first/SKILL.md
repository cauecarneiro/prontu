---
name: search-first
description: "Research-before-coding workflow para iOS/Swift. Obreiga o agente a buscar soluções nativas Apple, Swift Packages SDKs e padrões existentes antes de escrever código customizado."
origin: ECC (Optimized for iOS AI-Driven Dev)
---

# /search-first — Research Before You Code

Sistematiza o fluxo "procure por soluções existentes antes de implementar", crucial no ecossistema Apple, onde utilitários nativos ou frameworks first-party do iOS frequentemente já resolvem problemas complexos.

## Trigger

Use essa skill quando:
- Iniciar uma funcionalidade nova que pode ser resolvida pelo Foundation / SwiftUI framework.
- Ao pensar em adicionar um novo Swift Package.
- O usuário pede "adicione a funcionalidade X" e você está prestes a codificar do zero.
- Antes de criar um helper complexo de networking, decodificação, persistência, etc.

## Workflow

```text
┌─────────────────────────────────────────────┐
│  1. NEED ANALYSIS                           │
│     Definir requisitos da funcionalidade    │
│     Identificar target iOS nativo           │
├─────────────────────────────────────────────┤
│  2. PARALLEL SEARCH (Agent)                 │
│     ┌──────────┐ ┌──────────┐ ┌──────────┐  │
│     │ mcpbridge│ │  Swift / │ │ Local /  │  │
│     │ Apple Doc│ │  GitHub  │ │  Skills  │  │
│     └──────────┘ └──────────┘ └──────────┘  │
├─────────────────────────────────────────────┤
│  3. EVALUATE                                │
│     Pontuar: iOS native support, SPM,       │
│     Swift 6 Concurrency, HIG Compliance     │
├─────────────────────────────────────────────┤
│  4. DECIDE                                  │
│     ┌─────────┐  ┌──────────┐  ┌─────────┐  │
│     │ iOS     │  │ SPM      │  │ Custom  │  │
│     │ Native  │  │ Adopt    │  │ Build   │  │
│     └─────────┘  └──────────┘  └─────────┘  │
├─────────────────────────────────────────────┤
│  5. IMPLEMENT                               │
│     Import Foundation/Framework ou          │
│     Adicionar via Xcode SPM CLI             │
└─────────────────────────────────────────────┘
```

## Decision Matrix

| Signal                                      | Action                                             |
| ------------------------------------------- | -------------------------------------------------- |
| Solução existe no iOS SDK atualizado        | **Nativo First** — Importe o framework Apple       |
| SPM com suporte a Swift 6/Async, MIT/Apache | **Adopt SPM** — inclua no `Package.swift` / Xcode  |
| Package robusto, mas API pesada/difícil     | **Extend** — use o SPM + escreva uma thin wrapper  |
| Nada atende ou quebra padrões HIG/Apple     | **Build** — crie customizado (baseado em iOS Docs) |

## How to Use

### Quick Mode (Inline para iOS)

Antes de escrever a funcionalidade, o agente deve passar mentalmente por:
0. O código já existe localmente? → `rg` nos módulos `Sources/` e `Tests/`.
1. A Apple já resolveu isso? → Consulte o MCP `xcrun mcpbridge` (Semantic Search em Apple Docs & WWDC).
2. Existe uma skill de diretriz ou padrão do HIG local (ex. `hig-*`)? → Consulte primeiro.
3. É um padrão geral de comunidade? → Pesquise no Swift Package Index ou GitHub Code Search.

### Full Mode (Agent)

Para algo complexo, usar o agente pesquisador com foco Apple:

```text
Task(subagent_type="ios-strict-engineer", prompt="
  Busque ferramentas/frameworks para: [DESCRIÇÃO DO PROBLEMA]
  Plataforma: iOS / Swift 6 / SwiftUI
  
  Canais de Busca: 
  1. xcrun mcpbridge (Apple Docs/WWDC)
  2. Swift Package Index / Web Search
  
  Regras: Privilegie soluções First-Party da Apple. 
  Retorne: Comparação documentada e recomendação se devemos usar Nativo, SPM ou construir.
")
```

## Search Shortcuts by Category

### Networking & Data
- Cliente HTTP -> `URLSession` nativo (apenas escale para `Alamofire` caso exista regra severa de backward compatibility).
- Persistência -> `SwiftData` nativo ou `CoreData` via `@FetchRequest`.
- Serialização -> Protocolo `Codable` nativo e `JSONDecoder`.

### UI e Design
- Componentes padronizados -> Busque nas skills de HIG locais `hig-components-*`.
- Animações Lottie -> Considere `PhaseAnimator` e `KeyframeAnimator` (iOS 17+) antes de instalar bibliotecas.

### Testing e CI
- Unit Tests -> `Swift Testing` (`import Testing`) ou `XCTest`.
- Acessibilidade UI -> Validação pelo `xcode-ui-review` via UI Automation MCP.

## Integration Points

### With planner agent

The planner should invoke researcher before Phase 1 (Architecture Review):
- Pesquisador identifica se existe solução iOS nativa
- Planner incorpora a solução nativa ao plano (ex: usar SwiftData em vez de tentar SQL direto)
- Evita "reinventar a roda" em Swift

### With rfc-dag e continuous-agent-loop

Integrado ao ciclo autônomo e de PRs:
- O loop de `search-first` sempre antecede o loop de code-gen no `continuous-agent-loop`

## Exemplos de Adoção Swift-First

### Exemplo 1: "Adicionar parse de Markdown"

```
Necessidade: Exibir texto markdown nativo
Busca Inicial: Swift "markdown text"
Resultado: iOS 15+ introduziu Text(_: markdown:) nativamente e a lib swift-markdown da Apple.
Ação: iOS NATIVE — Usar nativo.
Resultado: Zero custom code ou bibliotecas externas.
```

### Exemplo 2: "Adicionar rede resiliente"

```
Necessidade: HTTP Client com Retries e Concurrency
Busca: SPM async http retry
Resultado: URLSession async/await nativo resolve o problema principal + task modifiers.
Ação: iOS NATIVE — Criar pequena helper class baseada em URLSession.
Resultado: Nenhuma terceira dependência adotada.
```

## Anti-Patterns
- **Pular a Apple**: Instalar um pacote Swift para resolver algo que um SDK do novo iOS já resolve por padrão de forma mais otimizada (ex: manipulação nativa de Regex do Swift 5.7).
- **Ignorar o SPM (Swift Package Manager)**: Usar Cocoapods ou Carthage sem checar primeiro se a dependência tem SPM.
- **Assumir Web Stack**: Tentar procurar coisas como Axios, Redux ou bibliotecas clássicas Web em vez de abraçar a mentalidade Swift-first (ex: Observation e Environment).
