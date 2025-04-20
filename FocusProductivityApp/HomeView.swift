//
//  ContentView.swift
//  FocusProductivityApp
//
//  Created by Mayur Kant Tyagi on 20/04/25.
//

import SwiftUI

// FocusProductivityApp.swift
import SwiftUI

// FocusMode.swift
enum FocusMode: String, CaseIterable, Identifiable, Codable {
    case work, play, rest, sleep

    var id: String { self.rawValue }
    var displayName: String { self.rawValue.capitalized }
}

// FocusSession.swift
struct FocusSession: Identifiable, Codable {
    let id = UUID()
    let mode: FocusMode
    let startTime: Date
    let duration: TimeInterval
    let points: Int
    let badges: [String]

    var formattedStartTime: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: startTime)
    }
}

// FocusSessionViewModel.swift
class FocusSessionViewModel: ObservableObject {
    @Published var currentMode: FocusMode?
    @Published var startTime: Date?
    @Published var elapsedTime: TimeInterval = 0
    @Published var points: Int = 0
    @Published var badges: [String] = []
    @Published var timerText: String = "00:00"
    @Published var sessionHistory: [FocusSession] = []

    private var timer: Timer?
    private let badgeOptions = ["🌵", "🎄", "🌲", "🌳", "🌴", "🍂", "🍁", "🍄", "🐅", "🦅", "🐵", "🐝"]

    func startSession(mode: FocusMode) {
        currentMode = mode
        startTime = Date()
        elapsedTime = 0
        points = 0
        badges = []
        startTimer()
    }

    func stopSession() {
        timer?.invalidate()
        guard let start = startTime, let mode = currentMode else { return }
        let session = FocusSession(mode: mode, startTime: start, duration: elapsedTime, points: points, badges: badges)
        sessionHistory.insert(session, at: 0)
        currentMode = nil
        elapsedTime = 0
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.updateTimer()
        }
    }

    private func updateTimer() {
        guard let start = startTime else { return }
        elapsedTime = Date().timeIntervalSince(start)

        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = elapsedTime >= 3600 ? [.hour, .minute, .second] : [.minute, .second]
        timerText = formatter.string(from: elapsedTime) ?? "00:00"

        if Int(elapsedTime) % 120 == 0 && Int(elapsedTime) != 0 {
            points += 1
            if let badge = badgeOptions.randomElement() {
                badges.append(badge)
            }
        }
    }
}

// HomeView.swift
struct HomeView: View {
    @EnvironmentObject var sessionVM: FocusSessionViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("Select Focus Mode")
                .font(.title)

            ForEach(FocusMode.allCases) { mode in
                NavigationLink(destination: FocusModeView(mode: mode)) {
                    Text(mode.displayName)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(12)
                }
            }

            NavigationLink("Go to Profile", destination: ProfileView())
                .padding(.top, 40)
        }
        .padding()
    }
}

// FocusModeView.swift
struct FocusModeView: View {
    let mode: FocusMode
    @EnvironmentObject var sessionVM: FocusSessionViewModel

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

// ProfileView.swift
struct ProfileView: View {
    @EnvironmentObject var sessionVM: FocusSessionViewModel
    let userName = "Rittwik Mondal"
    let userImage = "person.circle"

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Image(systemName: userImage)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .padding()

                Text(userName)
                    .font(.title2)
                Text("Total Points: \(sessionVM.sessionHistory.reduce(0) { $0 + $1.points })")

                Text("Badges:")
                Text(sessionVM.sessionHistory.flatMap { $0.badges }.joined(separator: " "))
                    .font(.largeTitle)

                Text("Recent Sessions")
                    .font(.headline)

                ForEach(sessionVM.sessionHistory) { session in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(session.mode.displayName)
                            .font(.headline)
                        Text("Duration: \(formatDuration(session.duration))")
                        Text("Points: \(session.points)")
                        Text("Start: \(session.formattedStartTime)")
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
            }
            .padding()
        }
    }

    func formatDuration(_ duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter.string(from: duration) ?? "--"
    }
}


#Preview {
    ContentView()
}
