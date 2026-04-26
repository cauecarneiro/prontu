//
//  EditClientView.swift
//  Challenge13
//
//  Created by Caio Mandarino on 01/04/26.
//

import SwiftUI

struct EditClientView: View {

    @ObservedObject var viewModel: EditClientViewModel
    @Namespace private var heroNamespace
    @State private var isCollapsed: Bool = false
    @FocusState private var focusedField: FocusField?

    private enum FocusField { case name, contactInfo }

    private enum Layout {
        static let expandedHeaderHeight: CGFloat = 190
        static let collapsedHeaderHeight: CGFloat = 88
        static let collapseThreshold: CGFloat = 60
        static let uncollapseThreshold: CGFloat = 20
        static let expandedAvatarSize: CGFloat = 80
        static let collapsedAvatarSize: CGFloat = 52
        static let expandedNameSize: CGFloat = 28
        static let collapsedNameSize: CGFloat = 19
        static let expandedPhoneSize: CGFloat = 15
        static let collapsedPhoneSize: CGFloat = 13
        static let horizontalPadding: CGFloat = 16
        static let morphSpring: Animation = .spring(response: 0.35, dampingFraction: 0.75)
        static let editSpring: Animation = .spring(response: 0.3, dampingFraction: 0.7)
    }

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Fixed spacer that reserves space for the pinned header overlay.
                // Always expandedHeaderHeight so content position never jumps.
                Color.clear.frame(height: Layout.expandedHeaderHeight)

                sessionHistoryContent
                    .padding(.horizontal, Layout.horizontalPadding)
                    .padding(.top, 8)
                    .padding(.bottom, 40)
            }
        }
        // onScrollGeometryChange is the correct iOS 17+ API for scroll-driven effects.
        // It fires reliably on every scroll frame, unlike PreferenceKey/GeometryReader.
        .onScrollGeometryChange(for: CGFloat.self) { geo in
            geo.contentOffset.y
        } action: { _, y in
            guard !viewModel.isEditing else { return }
            if !isCollapsed && y > Layout.collapseThreshold {
                withAnimation(Layout.morphSpring) { isCollapsed = true }
            } else if isCollapsed && y < Layout.uncollapseThreshold {
                withAnimation(Layout.morphSpring) { isCollapsed = false }
            }
        }
        .overlay(alignment: .top) {
            headerView
                .background(GlobalConfiguration.groupedBackground)
        }
        .background(GlobalConfiguration.groupedBackground)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            leadingToolbarItem
            trailingToolbarItems
        }
        .animation(Layout.editSpring, value: viewModel.isEditing)
    }

    // MARK: - Header (pinned overlay, switches on isCollapsed)

    @ViewBuilder
    private var headerView: some View {
        if isCollapsed && !viewModel.isEditing {
            collapsedHeader
        } else {
            expandedHeader
        }
    }

    // Expanded: avatar centered, name + phone stacked below
    private var expandedHeader: some View {
        VStack(spacing: 8) {
            Spacer(minLength: 12)

            avatarCircle(size: Layout.expandedAvatarSize)
                .matchedGeometryEffect(id: "avatar", in: heroNamespace)

            if viewModel.isEditing {
                TextField("Nome", text: $viewModel.name)
                    .font(.system(size: Layout.expandedNameSize, weight: .bold))
                    .multilineTextAlignment(.center)
                    .focused($focusedField, equals: .name)
                    .onAppear { if focusedField == nil { focusedField = .name } }
                    .padding(.horizontal, Layout.horizontalPadding)

                TextField("Telefone", text: $viewModel.contactInfo)
                    .font(.system(size: Layout.expandedPhoneSize))
                    .foregroundStyle(Color(red: 0.33, green: 0.33, blue: 0.33))
                    .keyboardType(.phonePad)
                    .multilineTextAlignment(.center)
                    .focused($focusedField, equals: .contactInfo)
                    .padding(.horizontal, Layout.horizontalPadding)
            } else {
                Text(viewModel.name)
                    .font(.system(size: Layout.expandedNameSize, weight: .bold))
                    .foregroundStyle(Color(red: 0.10, green: 0.10, blue: 0.10))
                    .lineLimit(1)
                    .minimumScaleFactor(0.3)
                    .matchedGeometryEffect(id: "name", in: heroNamespace)

                Text(viewModel.contactInfo)
                    .font(.system(size: Layout.expandedPhoneSize))
                    .foregroundStyle(Color(red: 0.33, green: 0.33, blue: 0.33))
                    .lineLimit(1)
                    .minimumScaleFactor(0.3)
                    .matchedGeometryEffect(id: "phone", in: heroNamespace)
            }

            Spacer(minLength: 12)
        }
        .frame(maxWidth: .infinity)
        .frame(height: Layout.expandedHeaderHeight)
    }

    // Collapsed: avatar leading, name + phone inline
    private var collapsedHeader: some View {
        HStack(spacing: 14) {
            avatarCircle(size: Layout.collapsedAvatarSize)
                .matchedGeometryEffect(id: "avatar", in: heroNamespace)

            VStack(alignment: .leading, spacing: 3) {
                Text(viewModel.name)
                    .font(.system(size: Layout.collapsedNameSize, weight: .bold))
                    .foregroundStyle(Color(red: 0.10, green: 0.10, blue: 0.10))
                    .lineLimit(1)
                    .minimumScaleFactor(0.3)
                    .matchedGeometryEffect(id: "name", in: heroNamespace)

                Text(viewModel.contactInfo)
                    .font(.system(size: Layout.collapsedPhoneSize))
                    .foregroundStyle(Color(red: 0.33, green: 0.33, blue: 0.33))
                    .lineLimit(1)
                    .minimumScaleFactor(0.3)
                    .matchedGeometryEffect(id: "phone", in: heroNamespace)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: Layout.collapsedHeaderHeight)
        .padding(.horizontal, Layout.horizontalPadding)
    }

    // MARK: - Avatar

    private func avatarCircle(size: CGFloat) -> some View {
        ZStack {
            Circle()
                .fill(GlobalConfiguration.avatarColor(for: viewModel.client.name))
            Text(viewModel.client.initials)
                .font(.system(size: size * 0.35, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)
        }
        .frame(width: size, height: size)
    }

    // MARK: - Session content

    private var sessionHistoryContent: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !viewModel.sortedAppointments.isEmpty {
                Text("Histórico de Sessões")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color(red: 0.55, green: 0.55, blue: 0.55))
                    .padding(.bottom, 4)

                ForEach(viewModel.sortedAppointments) { appointment in
                    SessionHistoryCard(appointment: appointment)
                }
            } else {
                VStack(spacing: 8) {
                    Image(systemName: "calendar.badge.clock")
                        .font(.system(size: 32))
                        .foregroundStyle(Color(uiColor: .systemGray3))
                    Text("Nenhuma sessão registrada")
                        .font(.system(size: 15))
                        .foregroundStyle(Color(uiColor: .systemGray))
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 40)
            }
        }
    }

    // MARK: - Toolbar

    @ToolbarContentBuilder
    private var leadingToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: viewModel.dismiss) {
                Image(systemName: "chevron.backward")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Color.primary)
            }
            .frame(maxWidth: 30)
            .tint(.black)
        }
    }

    @ToolbarContentBuilder
    private var trailingToolbarItems: some ToolbarContent {
        if viewModel.isEditing {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 12) {
                    Button("Cancelar") {
                        focusedField = nil
                        viewModel.cancelEdit()
                    }
                    .foregroundStyle(.secondary)

                    Button("Salvar") {
                        focusedField = nil
                        viewModel.save()
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(GlobalConfiguration.primaryBlue)
                    .disabled(!viewModel.canSave)
                }
            }
        } else {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button { viewModel.isEditing = true } label: {
                    Image(systemName: "pencil")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(Color.primary)
                }
                .frame(maxWidth: 30)
                .tint(.black)
            }
        }
    }
}

// MARK: - Previews

#Preview("Sem Sessões") {
    let db = makeRegisterFlowDatabaseService()
    let client = Client(name: "Ana Lima", contactInfo: "(21) 98765-4321")
    let vm = EditClientViewModel(client: client, databaseService: db, coordinator: nil)
    return NavigationStack {
        EditClientView(viewModel: vm)
    }
}
