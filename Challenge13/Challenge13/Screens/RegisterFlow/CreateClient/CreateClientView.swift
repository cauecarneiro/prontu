////
////  CreateClientView.swift
////  Challenge13
////
////  Created by Cauê Carneiro on 21/04/26.
////

import SwiftUI

struct CreateClientView: View {

    @ObservedObject var viewModel: CreateClientViewModel
    @State private var openImportContacts: Bool = false
    @FocusState private var focusedField: FocusField?

    private enum FocusField: Hashable {
        case name, contactInfo, observations
    }

    private enum ScrollAnchor: String {
        case contactSection
        case notesSection
    }

    private enum Layout {
        static let topBarHeight: CGFloat = 141
        static let topBarHorizontalPadding: CGFloat = 24
        static let iconButtonSize: CGFloat = 44
        static let inputRowHeight: CGFloat = 56
        static let textAreaHeight: CGFloat = 173
        static let footerHeight: CGFloat = 55
        static let footerBottomPadding: CGFloat = 32
        static let sectionHeaderFontSize: CGFloat = 16
        static let importContactFontSize: CGFloat = 14
        static let contactCardHorizontalPadding: CGFloat = 20
        static let contactCardVerticalPadding: CGFloat = 4
        static let textAreaHorizontalPadding: CGFloat = 18
        static let textAreaVerticalPadding: CGFloat = 16
        static let animationDuration: Double = 0.25
        static let entryScale: CGFloat = 0.95
        static let sectionsSpacing: CGFloat = 24
        static let sectionSpacing: CGFloat = 8
        static let textAreaIconSpacing: CGFloat = 4
        static let secondaryButtonOpacity: Double = 0.55
        static let ctaDisabledOpacity: Double = 0.35
        static let ctaDisabledScale: CGFloat = 0.98
        static let ctaStateAnimationDuration: Double = 0.3
    }

    var body: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView {
                ScrollViewReader { proxy in
                    VStack(spacing: Layout.sectionsSpacing) {
                        if !viewModel.name.isEmpty {
                            ClientPreviewCard(name: viewModel.name, contactInfo: viewModel.contactInfo)
                                .transition(
                                    .asymmetric(
                                        insertion: .opacity.combined(with: .scale(scale: Layout.entryScale, anchor: .top)),
                                        removal: .opacity.combined(with: .scale(scale: Layout.entryScale, anchor: .top))
                                    )
                                )
                        }
                        contactInfoSection
                            .id(ScrollAnchor.contactSection.rawValue)
                        notesSection
                            .id(ScrollAnchor.notesSection.rawValue)
                    }
                    .padding(.horizontal, GlobalConfiguration.normalSpacing)
                    .padding(.bottom, Layout.sectionsSpacing)
                    .onChange(of: focusedField) { _, field in
                        guard let field else { return }
                        let anchor: String = field == .observations
                            ? ScrollAnchor.notesSection.rawValue
                            : ScrollAnchor.contactSection.rawValue
                        withAnimation { proxy.scrollTo(anchor, anchor: .bottom) }
                    }
                }
            }
            .scrollDismissesKeyboard(.interactively)
            footer
        }
        .background(Color(.systemGroupedBackground))
        .background(
            ContactPickerView(isPresented: $openImportContacts) {
                viewModel.applyImportedContact($0)
            }
        )
        .animation(.easeInOut(duration: Layout.animationDuration), value: viewModel.name.isEmpty)
    }

    // MARK: - TopBar

    private var topBar: some View {
        HStack {
            iconButton(systemName: "xmark") {
                viewModel.dismiss()
            }
            Text("Novo Cliente")
                .font(.system(size: Layout.sectionHeaderFontSize + 2, weight: .bold))
                .frame(maxWidth: .infinity)
            Color.clear
                .frame(width: Layout.iconButtonSize, height: Layout.iconButtonSize)
        }
        .padding(.horizontal, Layout.topBarHorizontalPadding)
        .frame(height: Layout.topBarHeight)
    }

    private func iconButton(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: Layout.sectionHeaderFontSize, weight: .semibold))
                .foregroundStyle(.primary)
                .frame(width: Layout.iconButtonSize, height: Layout.iconButtonSize)
                .background(Color(.systemFill).opacity(Layout.secondaryButtonOpacity))
                .clipShape(RoundedRectangle(cornerRadius: GlobalConfiguration.largeCornerRadius))
        }
    }

    // MARK: - Contact Info Section

    private var contactInfoSection: some View {
        VStack(spacing: Layout.sectionSpacing) {
            HStack(alignment: .center) {
                Text("Informações de Contato")
                    .font(.system(size: Layout.sectionHeaderFontSize, weight: .semibold))
                    .foregroundStyle(.primary)
                Spacer()
                Button {
                    openImportContacts = true
                } label: {
                    Label("Importar Contato", systemImage: "person.badge.plus")
                        .font(.system(size: Layout.importContactFontSize))
                        .foregroundStyle(GlobalConfiguration.primaryBlue)
                }
            }
            .padding(.trailing, GlobalConfiguration.normalSpacing / 2)

            VStack(spacing: 0) {
                TextField("Nome do Cliente", text: $viewModel.name)
                    .font(.system(size: Layout.sectionHeaderFontSize, weight: .semibold))
                    .focused($focusedField, equals: .name)
                    .frame(height: Layout.inputRowHeight)
                Divider()
                TextField("Informação de Contato", text: $viewModel.contactInfo)
                    .font(.system(size: Layout.sectionHeaderFontSize, weight: .semibold))
                    .focused($focusedField, equals: .contactInfo)
                    .frame(height: Layout.inputRowHeight)
            }
            .padding(.horizontal, Layout.contactCardHorizontalPadding)
            .padding(.vertical, Layout.contactCardVerticalPadding)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: GlobalConfiguration.largeCornerRadius))
        }
    }

    // MARK: - Notes Section

    private var notesSection: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $viewModel.observations)
                .scrollContentBackground(.hidden)
                .font(.system(size: Layout.sectionHeaderFontSize))
                .focused($focusedField, equals: .observations)
                .padding(.horizontal, Layout.textAreaHorizontalPadding)
                .padding(.vertical, Layout.textAreaVerticalPadding)

            if focusedField != .observations && viewModel.observations.isEmpty {
                HStack(alignment: .top, spacing: Layout.textAreaIconSpacing) {
                    Image(systemName: "list.bullet")
                        .font(.system(size: Layout.sectionHeaderFontSize, weight: .bold))
                        .foregroundStyle(.primary)
                    Text("Anotações sobre o cliente...")
                        .font(.system(size: Layout.sectionHeaderFontSize))
                        .foregroundStyle(.placeholder)
                }
                .padding(.horizontal, Layout.textAreaHorizontalPadding)
                .padding(.vertical, Layout.textAreaVerticalPadding)
                .allowsHitTesting(false)
            }
        }
        .frame(height: Layout.textAreaHeight)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: GlobalConfiguration.largeCornerRadius))
        .onTapGesture { focusedField = .observations }
    }

    // MARK: - Footer

    private var footer: some View {
        Button {
            viewModel.save()
        } label: {
            Text("Criar Cliente")
                .font(.system(size: Layout.sectionHeaderFontSize, weight: .semibold))
                .foregroundStyle(.white.opacity(viewModel.canSave ? 1 : Layout.ctaDisabledOpacity))
                .frame(maxWidth: .infinity)
                .frame(height: Layout.footerHeight)
                .background(
                    GlobalConfiguration.primaryBlue
                        .opacity(viewModel.canSave ? 1 : Layout.ctaDisabledOpacity)
                )
                .clipShape(RoundedRectangle(cornerRadius: GlobalConfiguration.largeCornerRadius))
        }
        .disabled(!viewModel.canSave)
        .scaleEffect(viewModel.canSave ? 1 : Layout.ctaDisabledScale)
        .animation(
            .spring(response: Layout.ctaStateAnimationDuration, dampingFraction: 0.7),
            value: viewModel.canSave
        )
        .padding(.horizontal, GlobalConfiguration.normalSpacing)
        .padding(.top, GlobalConfiguration.normalSpacing)
        .padding(.bottom, Layout.footerBottomPadding)
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    let coordinator = makeRegisterFlowCoordinator()
    CreateClientView(viewModel: .init(
        databaseService: makeRegisterFlowDatabaseService(),
        coordinator: coordinator
    ))
}
