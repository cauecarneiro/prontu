---
paths:
  - "Challenge13/Challenge13/**/*.swift"
---

# Estrutura de Arquivos e Componentes

Preserve a topologia atual do projeto. Arquivos novos entram no diretório que já corresponde à sua responsabilidade; não crie pastas irmãs de `Screens/`, `Entity/`, `Services/`, `Helpers/`, `Views/` sem necessidade arquitetural clara.

## Diretórios raiz (`Challenge13/`)

- `Screens/` — um subdiretório por **Flow** (`<Nome>Flow/`). Ver `architecture-flows.md`.
- `Entity/` — modelos de domínio puros (`struct`/`enum`, `Codable` quando aplicável). Agrupar em subpasta quando formarem uma família (ex: `Entity/Week/`).
- `Services/` — camada de acesso a dados, sistema, persistência (`DatabaseService`, `SettingsStore`, `AppLockValidatorService`). Um arquivo por service.
- `Helpers/` — utilitários transversais. Manter subpastas existentes: `Extension/` (extensions de tipos Foundation/SwiftUI), `Navigation/` (core de navegação — ver regra de arquitetura), `GlobalConfiguration.swift`, `UserDefaultsKeys.swift`, `PreviewFuncs.swift`.
- `Views/` — componentes **compartilhados entre 2+ Flows**. Organizar por domínio (`Views/Agenda/`, `Views/Client/`).

## Onde mora um componente de UI

Critério em ordem:

1. **Usado por apenas uma tela** → `Screens/<Flow>/<Tela>/Components/<Componente>.swift`.
2. **Usado por 2+ telas do mesmo Flow** → `Screens/<Flow>/GeneralComponents/<Componente>.swift`.
3. **Usado por 2+ Flows distintos** → `Views/<Dominio>/<Componente>.swift`.

Ao promover um componente (subir de nível), mova o arquivo; não duplique. Um componente **nunca** deve existir em dois níveis simultaneamente.

## Convenções de nomenclatura

- Arquivo = nome do tipo principal que contém (`AgendaView.swift` contém `struct AgendaView`).
- Views: sufixo `View` (`AgendaView`, `WeekCalendarView`).
- ViewModels: sufixo `ViewModel`, `final class`, `@MainActor` quando apropriado.
- Protocolos de coordenação: `<Tela>CoordinatorProtocol` ou `<Tela>CoordinateProtocol` — siga o padrão já presente no flow em que estiver trabalhando (não misturar os dois no mesmo flow).
- Services: sufixo `Service`. Stores de configuração: sufixo `Store`.
- Extensões: `<Tipo>+<Escopo>.swift` em `Helpers/Extension/` (ex: `Date+Ext.swift`, `Binding+Ext.swift`).
- Enums de rota: `<Nome>FlowRouter`. Enums de tab: `TabItens` (padrão do projeto).

## Ao criar um arquivo novo

- Header padrão `//  <Arquivo>.swift  //  Challenge13  //  Created by <Autor> on <data>.` mantendo o estilo existente.
- Imports mínimos (`Foundation`, `SwiftUI`, `Combine` apenas se usados).
- Uma `struct`/`class`/`enum` de topo por arquivo; tipos auxiliares privados podem coexistir abaixo se forem internos àquele arquivo.

## Extração de sub-views

Sub-partes de uma View com nome semântico claro e mais de ~5 linhas devem ser extraídas como `struct` em arquivos separados, não como `private var` computadas na mesma struct.

```swift
// ❌ computed var embutida na View pai
private var header: some View {
    HStack { Text(title) ... }
}

// ✅ struct em arquivo próprio
// Components/CalendarWeeklyStripHeader.swift
struct CalendarWeeklyStripHeader: View { ... }
```

Funções auxiliares puras (sem `View`) e tipos de suporte (`private enum Layout`, structs de dados) podem coexistir no mesmo arquivo que as utiliza.

## Reutilização de extensões existentes

Antes de implementar lógica de formatação, parsing ou transformação, verifique se já existe uma extension em `Helpers/Extension/`. Reutilize — não duplique.

```swift
// ✅ reutiliza Date+Ext.swift
Text(selectedDate.formatterRow())

// ❌ reimplementa formatação inline
let month = selectedDate.formatted(.dateTime.month(.wide)...)
```
