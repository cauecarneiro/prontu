//
//  OnBoardingView.swift
//  Prontu!
//
//  Created by Luciana Liebl de Freitas on 27/04/26.
//
import SwiftUI
import Combine

struct OnBoardingView: View{

    @State private var currentPage = 0
    @State private var progress: Double = 0
    @State private var showConsent = false
    @State private var showFaceId = false
    @State private var isPaused = false
    @State private var pressStartTime: Date? = nil
    @State private var dragStartX: CGFloat = 0

    @StateObject private var profileViewModel = ProfileViewModel(coordinator: nil)

    var onComplete: () -> Void = {}

    private let pages = OnBoardingPage.mock
    private var total: Int { pages.count }

    var body: some View{
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()

            if showFaceId {
                faceIdScreen
                    .transition(.move(edge: .trailing))
            } else if showConsent {
                consentScreen
                    .transition(.move(edge: .trailing))
            } else {
                onboardingPages
                    .transition(.move(edge: .leading))
            }
        }
    }

    // MARK: - Tela de consentimento

    private var consentScreen: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    withAnimation(.easeInOut) { showConsent = false }
                    progress = 0
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundStyle(.primary)
                }
                .buttonStyle(.plain)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)

            ConsentView(acceptAction: {
                withAnimation(.easeInOut) { showFaceId = true }
            })
        }
    }

    // MARK: - Tela de Face ID

    private var faceIdScreen: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    withAnimation(.easeInOut) { showFaceId = false }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundStyle(.primary)
                }
                .buttonStyle(.plain)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)

            FaceIdView(viewModel: profileViewModel)

            ContinueButton(label: "Continuar", action: onComplete)
        }
    }

    // MARK: - Telas de onboarding

    private var onboardingPages: some View {
        VStack(spacing: 0) {
            // Header: botão voltar + barra de progresso
            HStack {
                Button { previousPage() } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundStyle(.primary)
                }
                .buttonStyle(.plain)
                .opacity(currentPage == 0 ? 0 : 1)

                ProgressBarView(
                    total: total,
                    currentPage: currentPage,
                    progress: progress
                )
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)

            // Área das páginas com gesto de toque e segurar
            GeometryReader { geo in
                TabView(selection: $currentPage){
                    ForEach(pages.indices, id: \.self){ i in
                        OnBoardingPageView(page: pages[i])
                            .tag(i)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            if pressStartTime == nil {
                                pressStartTime = value.time
                                dragStartX = value.startLocation.x
                            }
                            isPaused = true
                        }
                        .onEnded { value in
                            let duration = pressStartTime.map { value.time.timeIntervalSince($0) } ?? 1.0
                            pressStartTime = nil
                            isPaused = false

                            // Tap: toque rápido (<0.2s) com translação pequena (<20pt)
                            let wasTap = duration < 0.2
                                && max(abs(value.translation.width), abs(value.translation.height)) < 20

                            if wasTap {
                                if dragStartX < geo.size.width * 0.35 {
                                    previousPage()
                                } else {
                                    nextPage()
                                }
                            }
                        }
                )
            }

            // Botão fixo no rodapé
            ContinueButton(label: "Continuar", action: nextPage)
        }
        .onReceive(
            Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
        ) { _ in tick() }
        .onChange(of: currentPage) { _ in progress = 0 }
    }

    // MARK: - Lógica

    private func tick() {
        guard !isPaused else { return }
        let step = 0.05 / 5.0
        if progress < 1.0 {
            progress = min(progress + step, 1.0)
        } else if currentPage < total - 1 {
            nextPage()
        } else {
            withAnimation(.easeInOut) { showConsent = true }
        }
    }

    private func nextPage() {
        if currentPage < total - 1 {
            currentPage += 1
        } else {
            withAnimation(.easeInOut) { showConsent = true }
        }
    }

    private func previousPage() {
        if currentPage > 0 {
            currentPage -= 1
        }
    }
}
