//
//  StreamingTextView.swift
//  Challenge13
//

import SwiftUI

struct StreamingTextView: View {
    let text: String
    var wordInterval: Duration = .milliseconds(90)
    var initialBlur: CGFloat = 8
    var initialOffsetY: CGFloat = 4
    var skipAnimation: Bool = false
    var onTick: (() -> Void)? = nil

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var revealedTokenCount: Int = 0

    private var tokens: [Token] {
        Token.tokenize(text)
    }

    private var shouldAnimate: Bool {
        !skipAnimation && !reduceMotion
    }

    private var visibleTokens: [(offset: Int, token: Token)] {
        let target = shouldAnimate ? revealedTokenCount : tokens.count
        return Array(tokens.enumerated().prefix(target))
            .map { (offset: $0.offset, token: $0.element) }
    }

    var body: some View {
        WordFlowLayout(spacing: 0, lineSpacing: 4) {
            ForEach(visibleTokens, id: \.offset) { entry in
                switch entry.token {
                case .word(let value):
                    Text(value)
                        .font(.body)
                        .fixedSize(horizontal: true, vertical: false)
                        .transition(.streamWord(blur: initialBlur, offsetY: initialOffsetY))
                case .newline:
                    Color.clear
                        .frame(height: 0)
                        .modifier(LineBreakMarker())
                }
            }
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.85), value: revealedTokenCount)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(text)
        .task(id: text) {
            guard shouldAnimate else {
                revealedTokenCount = tokens.count
                return
            }
            revealedTokenCount = 0
            var wordsRevealedSinceTick = 0
            for (i, token) in tokens.enumerated() {
                if case .word = token {
                    do {
                        try await Task.sleep(for: wordInterval)
                    } catch {
                        return
                    }
                    revealedTokenCount = i + 1
                    wordsRevealedSinceTick += 1
                    if wordsRevealedSinceTick >= 4 {
                        onTick?()
                        wordsRevealedSinceTick = 0
                    }
                } else {
                    revealedTokenCount = i + 1
                }
            }
            onTick?()
        }
    }
}

// MARK: - Token

extension StreamingTextView {
    enum Token {
        case word(String)
        case newline

        static func tokenize(_ text: String) -> [Token] {
            var result: [Token] = []
            var buffer = ""

            func flushBuffer() {
                if !buffer.isEmpty {
                    result.append(.word(buffer))
                    buffer = ""
                }
            }

            for char in text {
                if char == "\n" {
                    flushBuffer()
                    result.append(.newline)
                } else if char == " " {
                    buffer.append(" ")
                    flushBuffer()
                } else {
                    buffer.append(char)
                }
            }
            flushBuffer()
            return result
        }
    }
}

// MARK: - Stream word transition

private struct StreamWordModifier: ViewModifier {
    let active: Bool
    let blur: CGFloat
    let offsetY: CGFloat

    func body(content: Content) -> some View {
        content
            .opacity(active ? 0 : 1)
            .blur(radius: active ? blur : 0)
            .offset(y: active ? offsetY : 0)
    }
}

private extension AnyTransition {
    static func streamWord(blur: CGFloat, offsetY: CGFloat) -> AnyTransition {
        .modifier(
            active: StreamWordModifier(active: true, blur: blur, offsetY: offsetY),
            identity: StreamWordModifier(active: false, blur: blur, offsetY: offsetY)
        )
    }
}

// MARK: - Line break marker

private struct LineBreakMarker: ViewModifier {
    func body(content: Content) -> some View {
        content.layoutValue(key: ForceLineBreakKey.self, value: true)
    }
}

private struct ForceLineBreakKey: LayoutValueKey {
    static let defaultValue: Bool = false
}

// MARK: - WordFlowLayout

struct WordFlowLayout: Layout {
    var spacing: CGFloat = 0
    var lineSpacing: CGFloat = 4

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        let rows = computeRows(subviews: subviews, maxWidth: maxWidth)

        var totalHeight: CGFloat = 0
        var maxRowWidth: CGFloat = 0
        for (i, row) in rows.enumerated() {
            totalHeight += row.height
            if i < rows.count - 1 { totalHeight += lineSpacing }
            maxRowWidth = max(maxRowWidth, row.width)
        }
        return CGSize(
            width: maxRowWidth,
            height: totalHeight
        )
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let rows = computeRows(subviews: subviews, maxWidth: bounds.width)
        var y = bounds.minY
        for row in rows {
            var x = bounds.minX
            for item in row.items {
                let size = item.size
                item.subview.place(
                    at: CGPoint(x: x, y: y),
                    proposal: ProposedViewSize(size)
                )
                x += size.width + spacing
            }
            y += row.height + lineSpacing
        }
    }

    private struct RowItem {
        let subview: LayoutSubview
        let size: CGSize
    }

    private struct Row {
        var items: [RowItem]
        var width: CGFloat
        var height: CGFloat
    }

    private func computeRows(subviews: Subviews, maxWidth: CGFloat) -> [Row] {
        var rows: [Row] = []
        var current = Row(items: [], width: 0, height: 0)

        for subview in subviews {
            let isBreak = subview[ForceLineBreakKey.self]
            if isBreak {
                rows.append(current)
                current = Row(items: [], width: 0, height: 0)
                continue
            }

            let size = subview.sizeThatFits(.unspecified)

            if current.width + size.width > maxWidth, !current.items.isEmpty {
                rows.append(current)
                current = Row(items: [], width: 0, height: 0)
            }

            current.items.append(RowItem(subview: subview, size: size))
            current.width += size.width + spacing
            current.height = max(current.height, size.height)
        }

        if !current.items.isEmpty || rows.isEmpty {
            rows.append(current)
        }
        return rows
    }
}
