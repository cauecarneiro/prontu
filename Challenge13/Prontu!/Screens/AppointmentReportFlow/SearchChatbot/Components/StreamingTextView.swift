//
//  StreamingTextView.swift
//  Challenge13
//

import SwiftUI

struct StreamingTextView: View {
    let text: String
    var wordInterval: Duration = .milliseconds(90)
    var revealDuration: Double = 0.45
    var initialBlur: CGFloat = 8
    var onTick: (() -> Void)? = nil

    @State private var revealedWords: Int = 0

    private var tokens: [Token] {
        Token.tokenize(text)
    }

    var body: some View {
        WordFlowLayout(spacing: 0, lineSpacing: 2) {
            ForEach(Array(tokens.enumerated()), id: \.offset) { index, token in
                switch token {
                case .word(let value):
                    Text(value)
                        .font(.body)
                        .opacity(index < revealedWords ? 1 : 0)
                        .blur(radius: index < revealedWords ? 0 : initialBlur)
                        .animation(.easeOut(duration: revealDuration), value: revealedWords)
                case .newline:
                    Color.clear
                        .frame(height: 0)
                        .modifier(LineBreakMarker())
                }
            }
        }
        .task(id: text) {
            revealedWords = 0
            for (i, token) in tokens.enumerated() {
                guard case .word = token else {
                    revealedWords = i + 1
                    continue
                }
                do {
                    try await Task.sleep(for: wordInterval)
                } catch {
                    return
                }
                revealedWords = i + 1
                onTick?()
            }
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

// MARK: - Line break marker (used by WordFlowLayout)

private struct LineBreakMarker: ViewModifier {
    func body(content: Content) -> some View {
        content.layoutValue(key: ForceLineBreakKey.self, value: true)
    }
}

private struct ForceLineBreakKey: LayoutValueKey {
    static let defaultValue: Bool = false
}

// MARK: - WordFlowLayout (leading-aligned, supports forced line breaks)

struct WordFlowLayout: Layout {
    var spacing: CGFloat = 0
    var lineSpacing: CGFloat = 2

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
            width: proposal.width ?? maxRowWidth,
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
