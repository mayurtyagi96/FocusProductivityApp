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
        VStack(spacing: 24) {
            Text("Focusing on \(mode.displayName)")
                .font(.title2)

            Text(sessionVM.timerText)
                .font(.system(size: 48, weight: .bold, design: .monospaced))

            Text("Points: \(sessionVM.points)")
            Text("Badges: \(sessionVM.badges.joined(separator: " "))")

            Button("Stop Focusing") {
                sessionVM.stopSession()
            }
            .foregroundColor(.red)
            .padding()
        }
        .onAppear {
            sessionVM.startSession(mode: mode)
        }
        .padding()
    }
}
