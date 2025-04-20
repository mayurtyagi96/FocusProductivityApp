//
//  HomeView.swift
//  FocusProductivityApp
//
//  Created by Mayur Kant Tyagi on 20/04/25.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var sessionVM: FocusSessionViewModel
    @State private var animateGradient = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.15),
                    Color.purple.opacity(0.1)
                ]),
                startPoint: animateGradient ? .topLeading : .topTrailing,
                endPoint: animateGradient ? .bottomTrailing : .bottomLeading
            )
            .ignoresSafeArea()
            .overlay(
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.05))
                        .frame(width: 300)
                        .blur(radius: 30)
                        .offset(x: -100, y: -200)
                    
                    Circle()
                        .fill(Color.purple.opacity(0.05))
                        .frame(width: 250)
                        .blur(radius: 25)
                        .offset(x: 120, y: 300)
                }
            )
            
            ScrollView {
                VStack(spacing: 35) {
                    VStack(spacing: 8) {
                        Text("Focus & Productivity")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.primary, .primary.opacity(0.7)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        Text("Build better habits, one session at a time")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 15)
                    
                    HStack(spacing: 20) {
                             statCard(
                                 title: "Total Points",
                                 value: "\(sessionVM.sessionHistory.reduce(0) { $0 + $1.points })",
                                 icon: "star.fill",
                                 color: .yellow
                             )
                             
                             statCard(
                                 title: "Sessions",
                                 value: "\(sessionVM.sessionHistory.count)",
                                 icon: "clock.fill",
                                 color: .blue
                             )
                         }
                    
                    VStack(spacing: 20) {
                        Text("Choose Your Focus Mode")
                            .font(.title3.bold())
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        focusModeGrid
                    }
                    
                    NavigationLink(destination: ProfileView(sessionVM: sessionVM)) {
                        HStack {
                            Image(systemName: "person.crop.circle.fill")
                                .font(.title2)
                                .foregroundColor(.blue)
                            
                            Text("View Profile")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.subheadline.bold())
                                .foregroundColor(.secondary.opacity(0.7))
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.ultraThinMaterial)
                                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
                        )
                    }
                    .padding(.top, 10)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .scrollIndicators(.hidden)
            .scrollBounceBehavior(.basedOnSize)
            
        }
        .onAppear {
            withAnimation(Animation.linear(duration: 7).repeatForever(autoreverses: true)) {
                animateGradient.toggle()
            }
        }
    }
    
    // MARK: - UI Components
    
    private var focusModeGrid: some View {
        LazyVGrid(
            columns: [GridItem(.flexible()), GridItem(.flexible())],
            spacing: 16
        ) {
            ForEach(FocusMode.allCases) { mode in
                NavigationLink(destination: FocusModeView(mode: mode, sessionVM: sessionVM)) {
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(iconBackgroundColor(for: mode).opacity(0.15))
                                .frame(width: 70, height: 70)
                            
                            Image(systemName: icon(for: mode))
                                .font(.system(size: 28))
                                .foregroundColor(iconColor(for: mode))
                        }
                        
                        VStack(spacing: 4) {
                            Text(mode.displayName)
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.primary)

                            Text(description(for: mode))
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .frame(height: 160)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.ultraThinMaterial)
                            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        iconColor(for: mode).opacity(0.3),
                                        iconColor(for: mode).opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    )
                }
            }
        }
    }
    
    // MARK: - Helper Views and Functions
    
    private func statCard(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text(value)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
        )
    }
    
    func icon(for mode: FocusMode) -> String {
        switch mode {
        case .work: return "briefcase.fill"
        case .play: return "gamecontroller.fill"
        case .rest: return "cup.and.saucer.fill"
        case .sleep: return "moon.stars.fill"
        }
    }
    
    func iconColor(for mode: FocusMode) -> Color {
        switch mode {
        case .work: return .blue
        case .play: return .purple
        case .rest: return .orange
        case .sleep: return .indigo
        }
    }
    
    func iconBackgroundColor(for mode: FocusMode) -> Color {
        switch mode {
        case .work: return .blue
        case .play: return .purple
        case .rest: return .orange
        case .sleep: return .indigo
        }
    }
    
    func description(for mode: FocusMode) -> String {
        switch mode {
        case .work: return "Deep focused work sessions"
        case .play: return "Balanced recreation time"
        case .rest: return "Short breaks to recharge"
        case .sleep: return "Track quality sleep time"
        }
    }
}
