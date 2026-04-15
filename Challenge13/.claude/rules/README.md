# Claude Rules — Challenge13

> **Última atualização:** 2026-04-15
> **Responsável:** fbtostadev@gmail.com
> **Escopo:** Rules ativas para o projeto `Challenge13` (SwiftUI · MVVM-C).

Este diretório agrupa as instruções modulares carregadas automaticamente pelo Claude Code ao trabalhar neste projeto. Cada arquivo tem `paths` no frontmatter que definem quando é aplicada.

---

## Índice de Rules

| # | Arquivo | Escopo (paths) | Resumo |
|---|---------|----------------|--------|
| 1 | [`architecture-flows.md`](./architecture-flows.md) | `Screens/**/*.swift`, `Helpers/Navigation/**/*.swift` | Padrão **MVVM-C**: estrutura obrigatória de um Flow (`Core/` com Coordinator + Factory + Router e subpastas por tela com View + ViewModel + CoordinatorProtocol). Core de navegação é **incremental-only**. |
| 2 | [`global-configuration.md`](./global-configuration.md) | Todo o projeto | **Zero magic numbers**: spacings, paddings, radii, cores, durações, fontes etc. sempre via `Helpers/GlobalConfiguration.swift` ou `Assets.xcassets`. Exceção: `0` e `1`. |
| 3 | [`file-structure.md`](./file-structure.md) | Todo o projeto | Topologia fixa (`Screens/`, `Entity/`, `Services/`, `Helpers/`, `Views/`) e hierarquia de componentes: **Components/ local → GeneralComponents/ do flow → Views/ compartilhado** entre flows. Sem duplicação. |

---

## Resumo das Regras

### 1. Arquitetura e Navegação (MVVM-C)

- Toda tela nova pertence a um **Flow** em `Screens/<Nome>Flow/`.
- `Core/` contém três arquivos: `<Nome>FlowCoordinator.swift`, `<Nome>FlowFactory.swift`, `<Nome>FlowRouter.swift`.
- Cada tela vive em `Screens/<Flow>/<Tela>/` com `View`, `ViewModel` e `<Tela>CoordinatorProtocol`.
- Coordinator é `final class`, expõe `rootView` e `coordinate(to:)` (`@MainActor @ViewBuilder`, switch exaustivo no Router).
- Factory injeta Services via init, guarda ViewModels como `private lazy var` e é configurada com `factory.coordinator = self`.
- Router é `enum` com associated values para dados das telas destino.
- ViewModel recebe `coordinator: <Tela>CoordinateProtocol?` (protocolo, nunca a classe concreta).
- `Helpers/Navigation/` é **incremental-only**: adicionar capacidades sim, remover/quebrar não.

### 2. GlobalConfiguration (Zero Magic Numbers)

- Proibido literal numérico em Views para valores visuais (spacing, padding, cornerRadius, frame fixo, font size, opacity, duração de animação).
- Proibido cor literal (`Color.red`, `Color(hex:)`). Sempre `GlobalConfiguration.<nome>` ou `Color(.<assetName>)`.
- Todo valor recebe **nome semântico** (o nome fala do uso, não do valor): `normalSpacing` ✅ · `sixteen` ❌.
- Exceções: apenas `0` e `1`.

### 3. Estrutura de Arquivos e Componentes

- Diretórios raiz fixos: `Screens/`, `Entity/`, `Services/`, `Helpers/`, `Views/`.
- Componente de UI mora conforme uso:
  1. Uma tela → `Screens/<Flow>/<Tela>/Components/`.
  2. 2+ telas do mesmo flow → `Screens/<Flow>/GeneralComponents/`.
  3. 2+ flows → `Views/<Dominio>/`.
- Ao promover um componente, **mover** (nunca duplicar).
- Convenções: `View`/`ViewModel`/`Service`/`Store`; extensões em `Helpers/Extension/` como `<Tipo>+<Escopo>.swift`; um tipo público por arquivo.

---

## Como adicionar ou alterar uma rule

1. Criar/editar o arquivo `.md` neste diretório com frontmatter `paths:` quando o escopo for limitado (ou sem frontmatter para global).
2. Atualizar este `README.md`: bumpar a data no topo e refletir a mudança no índice e no resumo.
3. Evitar conflito com as outras rules — se uma nova regra contradiz outra existente, atualizar ambas explicitamente.

## Changelog

- **2026-04-15** — Versão inicial. Criadas `architecture-flows.md`, `global-configuration.md` e `file-structure.md`.
