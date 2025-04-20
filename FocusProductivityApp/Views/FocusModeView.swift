//
//  FocusModeView.swift
//  FocusProductivityApp
//
//  Created by Mayur Kant Tyagi on 20/04/25.
//

import SwiftUI

struct FocusModeView: View {
    let mode: FocusMode
    @ObservedObject var sessionVM: FocusSessionViewModel

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Color.blue.opacity(0.1)
                Color.purple.opacity(0.1)
            }
            .ignoresSafeArea()
            
            Circle()
                .fill(Color.blue.opacity(0.05))
                .frame(width: 300, height: 300)
                .blur(radius: 20)
                .offset(x: -100, y: -200)
            
            Circle()
                .fill(Color.purple.opacity(0.05))
                .frame(width: 250, height: 250)
                .blur(radius: 15)
                .offset(x: 120, y: 300)
            
            VStack(spacing: 40) {
                VStack(spacing: 10) {
                    Text("FOCUS MODE")
                        .font(.caption.bold())
                        .tracking(2)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(.ultraThinMaterial)
                        )
                    
                    Text(mode.displayName)
                        .font(.system(size: 36, weight: .black))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                }
                
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 220, height: 220)
                        .shadow(color: .black.opacity(0.1), radius: 10)
                    
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [.blue, .purple, .blue],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: 6
                        )
                        .frame(width: 220, height: 220)
                    
                    Text(sessionVM.timerText)
                        .font(.system(size: 58, weight: .heavy, design: .rounded))
                        .foregroundColor(.primary)
                }
                
                VStack(spacing: 20) {
                    HStack(spacing: 24) {
                        metricBox(title: "Points", value: "\(sessionVM.points)", icon: "sparkles")
                        
                        Divider()
                            .frame(height: 40)
                        
                        metricBox(title: "Badges", value: sessionVM.badges.joined(separator: " "), icon: "star.fill")
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(.ultraThinMaterial)
                            .shadow(color: .black.opacity(0.1), radius: 8)
                    )
                }
                
                Spacer()
                
                Button(action: {
                    sessionVM.stopSession()
                }) {
                    Text("Stop Focusing")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 58)
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(
                                colors: [.red, Color(red: 0.9, green: 0.3, blue: 0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(20)
                        .shadow(color: .red.opacity(0.3), radius: 8, x: 0, y: 4)
                }
            }
            .padding(24)
        }
        .onAppear {
            sessionVM.startSession(mode: mode)
        }
    }

    func metricBox(title: String, value: String, icon: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.accentColor)
                .padding(.bottom, 2)
            
            Text(value)
                .font(.title2.bold())
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            
            Text(title)
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .tracking(1)
        }
        .frame(maxWidth: .infinity)
    }
}
