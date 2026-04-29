# AGENTS.md — Organizador_Itinerantes

Este arquivo define as instrucoes de projeto para o Codex.

## Escopo

- Repositorio principal: `Organizador_Itinerantes`
- Aplicacao iOS alvo destas regras: `Challenge13/Challenge13`
- Ao editar arquivos fora de `Challenge13/Challenge13`, nao aplicar regras de arquitetura iOS que dependem de `Screens/`, `Helpers/` e `Views/`.

## Regras Globais do App (`Challenge13/Challenge13/**/*.swift`)

### GlobalConfiguration (zero magic numbers em UI)

- Nao usar literais numericos inline em Views para:
  `spacing`, `padding`, `cornerRadius`, `frame` fixo (`width`/`height`), `font size`, `lineSpacing`, `offset`, `opacity`, duracao de animacao.
- Excecoes permitidas: `0` e `1`.
- Nao usar cores literais em Views (`Color.red`, `Color(hex:)`, `Color(.sRGB, ...)`).
- Valores reutilizaveis devem ficar em `Helpers/GlobalConfiguration.swift` com nome semantico.
- Cores novas devem ser criadas em `Assets.xcassets` e expostas via `GlobalConfiguration`.

Regra de reutilizacao:
- Se um valor visual for usado em 2+ arquivos, promover para `GlobalConfiguration`.
- Se for exclusivo de um unico componente/tela, manter local no arquivo com `private enum Layout`.

### Estrutura de arquivos e componentes

Diretorios raiz esperados dentro de `Challenge13/Challenge13`:
- `Screens/`
- `Entity/`
- `Services/`
- `Helpers/`
- `Views/`

Onde cada componente de UI deve morar:
1. Uso em uma unica tela: `Screens/<Flow>/<Tela>/Components/`
2. Uso em 2+ telas do mesmo flow: `Screens/<Flow>/GeneralComponents/`
3. Uso em 2+ flows: `Views/<Dominio>/`

Regras complementares:
- Ao promover componente, mover o arquivo (nao duplicar em dois niveis).
- Arquivo deve refletir o tipo principal (`AgendaView.swift` -> `AgendaView`).
- Extensoes devem ficar em `Helpers/Extension/` com padrao `<Tipo>+<Escopo>.swift`.
- Reutilizar extensoes existentes antes de criar nova logica inline.
- Em geral, manter um tipo publico de topo por arquivo.

## Regras de Arquitetura e Navegacao

Estas regras se aplicam quando editar:
- `Challenge13/Challenge13/Screens/**/*.swift`
- `Challenge13/Challenge13/Helpers/Navigation/**/*.swift`

Arquitetura obrigatoria: **MVVM-C** com **Coordinator + Factory + Router** por Flow.

### Estrutura obrigatoria por Flow

`Screens/<Nome>Flow/` deve seguir:
- `Core/<Nome>FlowCoordinator.swift`
- `Core/<Nome>FlowFactory.swift`
- `Core/<Nome>FlowRouter.swift`
- Subpastas de tela com:
  - `<Tela>View.swift`
  - `<Tela>ViewModel.swift`
  - `<Tela>CoordinatorProtocol.swift` (ou `<Tela>CoordinateProtocol.swift`, mantendo consistencia no flow)
  - `Components/` (opcional)

### Coordinator

- `final class <Nome>FlowCoordinator: Coordinator`
- Deve manter `navigationController: NavigationController = .init()`
- Receber factory via init e setar `factory.coordinator = self`
- `rootView` e `coordinate(to:)` com `@MainActor @ViewBuilder`
- `coordinate(to:)` com `switch` exaustivo no router (sem `default`)
- Navegacao concreta fica no coordinator; View nao usa `navigationController` diretamente

### Factory

- `final class <Nome>FlowFactory`
- Injecao de services via init
- `weak var coordinator`
- ViewModels persistidos como `private lazy var` por tela (evitar recriacao a cada push)
- Um metodo `make<Tela>View()` por tela

### Router

- `enum <Nome>FlowRouter` com um `case` por destino
- Dados entre telas via associated values (sem singleton/UserDefaults para comunicacao entre telas do mesmo flow)

### View e ViewModel

- View recebe ViewModel por injecao
- ViewModel recebe coordinator via protocolo (nao classe concreta)
- Acao de navegacao parte da ViewModel e delega para protocolo do coordinator

### Core de navegacao (`Helpers/Navigation`)

- Regra **incremental-only**
- Permitido: adicionar capacidades, tipos e extensoes
- Proibido: remover/quebrar APIs existentes do core de navegacao

## Prioridade e manutencao

- Para Codex, este `AGENTS.md` e a fonte principal de instrucoes do repositorio.
- As rules legadas em `.agents/rules/` podem ser mantidas por compatibilidade com outros agentes, mas devem permanecer consistentes com este arquivo.
