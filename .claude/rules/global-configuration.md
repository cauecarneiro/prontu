---
paths:
  - "Challenge13/Challenge13/**/*.swift"
---

# GlobalConfiguration — Zero Magic Numbers

Toda constante visual/numérica reutilizável mora em `Helpers/GlobalConfiguration.swift`. Cores nomeadas moram em `Assets.xcassets` e são expostas via `GlobalConfiguration`.

## Proibições

- **Nenhum** literal numérico em Views para: `spacing`, `padding`, `cornerRadius`, `frame` (width/height fixos), `font size`, `lineSpacing`, `offset`, `opacity`, durações de animação.
- **Nenhuma** cor literal em Views: proibido `Color.red`, `Color(hex:)`, `Color(.sRGB, ...)`. Use `GlobalConfiguration.<nome>` ou `Color(.<assetName>)`.
- Exceções permitidas: `0`, `1` (identidade, multiplicadores, índices triviais).

## Como adicionar

1. Abrir `Helpers/GlobalConfiguration.swift`.
2. Adicionar `static var` no `enum GlobalConfiguration` com nome semântico (não o valor):
   ```swift
   static var normalSpacing: CGFloat { 16 }       // ✅ nome fala do uso
   static var sixteen: CGFloat { 16 }              // ❌ nome fala do valor
   ```
3. Cores novas: criar Color Set em `Assets.xcassets` e expor em `GlobalConfiguration`:
   ```swift
   static var primaryGreen: Color { Color(.primaryGreen) }
   ```
4. Agrupar por família quando o conjunto crescer (spacings, radii, durations) — mantendo o `enum` único.

## Uso em Views

```swift
// ✅
VStack(spacing: GlobalConfiguration.normalSpacing) { ... }
    .padding(GlobalConfiguration.normalSpacing)
    .background(GlobalConfiguration.primaryGreen)
    .cornerRadius(GlobalConfiguration.normalCornerRadius)

// ❌
VStack(spacing: 16) { ... }
    .padding(16)
    .background(Color.green)
    .cornerRadius(12)
```

## Valores específicos de tela: constantes locais

Frames, paddings, tamanhos de fonte e espaçamentos **exclusivos de um único componente** não entram no `GlobalConfiguration`. Mantenha-os como `private enum Layout` no próprio arquivo:

```swift
// ✅ constante local nomeada
private enum Layout {
    static let headerHeight: CGFloat = 52
    static let dotSize: CGFloat = 5
}

// ❌ não jogar no GlobalConfiguration só para evitar inline
static var calendarPaddingTop: CGFloat { 12 }
```

O critério de entrada no `GlobalConfiguration` é **reutilização real em 2+ arquivos distintos**:
- Pertencem ao `GlobalConfiguration`: `normalSpacing`, `normalCornerRadius`, `primaryBlue`.
- Ficam locais: tamanho de chevron, altura do pager semanal, padding exclusivo de um componente.

Valores locais **ainda precisam de nome** (proibido literal inline) — a diferença é onde o nome vive.
