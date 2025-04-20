//
//  FocusSessionViewModel.swift
//  FocusProductivityApp
//
//  Created by Mayur Kant Tyagi on 20/04/25.
//

import SwiftUI

class FocusSessionViewModel: ObservableObject {
    @Published var currentMode: FocusMode?
    @Published var startTime: Date?
    @Published var elapsedTime: TimeInterval = 0
    @Published var points: Int = 0
    @Published var badges: [String] = []
    @Published var timerText: String = "00:00"
    @Published var sessionHistory: [FocusSession] = []
    @Published var profile: Profile
    
    init (){
        sessionHistory = FocusSessionDataManager.shared.getAllSessions()
        if let profile = ProfileDataManager.shared.getProfile(){
            self.profile = profile
        }else{
            let newProfile = Profile(name: "Mayur Kant Tyagi", image: "person.circle")
            self.profile = newProfile
            ProfileDataManager.shared.createProfile(profile: newProfile)
        }
    }

    private var timer: Timer?
    private let badgeOptions = ["🌵", "🎄", "🌲", "🌳", "🌴", "🍂", "🍁", "🍄", "🐅", "🦅", "🐵", "🐝"]

    func startSession(mode: FocusMode) {
        guard currentMode != mode else{ return }
        stopSession()
        timerText = "00:00"
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
        FocusSessionDataManager.shared.createSession(focusSession: session)
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
