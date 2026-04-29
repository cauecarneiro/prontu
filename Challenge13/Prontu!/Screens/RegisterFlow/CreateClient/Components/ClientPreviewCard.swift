//
//  ClientPreviewCard.swift
//  Challenge13
//
//  Created by Cauê Carneiro on 21/04/26.
//

import SwiftUI

struct ClientPreviewCard: View {

    let name: String
    let contactInfo: String

    @State private var shimmerPhase: CGFloat = 0
    @State private var isShimmering: Bool = false

    private enum Layout {
        static let avatarSize: CGFloat = 92
        static let avatarFontSize: CGFloat = 24
        static let nameFontSize: CGFloat = 24
        static let contactFontSize: CGFloat = 18
        static let cardPadding: CGFloat = 22
        static let infoVerticalPadding: CGFloat = 4
        static let shimmerDuration: Double = 0.8
        static let shimmerOpacity: Double = 0.35
    }

    var body: some View {
        ZStack {
            cardContent
            if isShimmering {
                shimmerOverlay
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: GlobalConfiguration.normalCornerRadius))
        .onAppear { triggerShimmer() }
        .onChange(of: name) { _, _ in triggerShimmer() }
        .onChange(of: contactInfo) { _, _ in triggerShimmer() }
    }

    // MARK: - Card Content

    private var cardContent: some View {
        HStack(spacing: 0) {
            avatarView
            Spacer()
            infoStack
        }
        .padding(Layout.cardPadding)
        .background(.white)
    }

    private var avatarView: some View {
        ZStack {
            Circle()
                .fill(GlobalConfiguration.avatarColor(for: name))
                .frame(width: Layout.avatarSize, height: Layout.avatarSize)
            Text(initials(from: name))
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)
        }
    }

    private var infoStack: some View {
        VStack(alignment: .trailing, spacing: 0) {
            Text(name)
                .font(.system(size: Layout.nameFontSize, weight: .medium))
                .foregroundStyle(.primary)
                .lineLimit(1)

            if !contactInfo.isEmpty {
                Label(contactInfo, systemImage: "phone.fill")
                    .font(.system(size: Layout.contactFontSize))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .padding(.vertical, Layout.infoVerticalPadding)
    }

    // MARK: - Shimmer

    private var shimmerOverlay: some View {
        GeometryReader { geo in
            let w = geo.size.width
            LinearGradient(
                stops: [
                    .init(color: .clear, location: 0.2),
                    .init(color: .white.opacity(Layout.shimmerOpacity), location: 0.5),
                    .init(color: .clear, location: 0.8)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width: w * 3)
            .offset(x: -2 * w + shimmerPhase * 3 * w)
        }
        .clipped()
        .allowsHitTesting(false)
        .onAppear { animateShimmer() }
    }

    private func animateShimmer() {
        shimmerPhase = 0
        withAnimation(.easeInOut(duration: Layout.shimmerDuration)) {
            shimmerPhase = 1
        }
    }

    private func triggerShimmer() {
        isShimmering = true
        shimmerPhase = 0
        withAnimation(.easeInOut(duration: Layout.shimmerDuration)) {
            shimmerPhase = 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + Layout.shimmerDuration) {
            isShimmering = false
            shimmerPhase = 0
        }
    }

    // MARK: - Helpers

    private func initials(from name: String) -> String {
        let words = name.split(separator: " ").map(String.init)
        switch words.count {
        case 0:
            return ""
        case 1:
            return String(words[0].prefix(2)).uppercased()
        default:
            let first = words[0].prefix(1)
            let last = words[words.count - 1].prefix(1)
            return (first + last).uppercased()
        }
    }
}

#Preview {
    VStack(spacing: GlobalConfiguration.normalSpacing) {
        ClientPreviewCard(name: "Cauê Carneiro", contactInfo: "61 9999-9999")
        ClientPreviewCard(name: "Ana", contactInfo: "")
        ClientPreviewCard(name: "Pedro Silva", contactInfo: "11 98765-4321")
    }
    .padding(GlobalConfiguration.normalSpacing)
    .background(Color(.systemGroupedBackground))
}
