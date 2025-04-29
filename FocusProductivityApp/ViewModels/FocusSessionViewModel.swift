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
    
    var currentSessions: [CurrentSessions] = []
    @Published var sessionHistory: [FocusSession] = []
    @Published var profile: Profile
    
    // Keys for UserDefaults
    private let activeSessionKey = "activeSession"
    private let startTimeKey = "sessionStartTime"
    private let modeKey = "sessionMode"
    private let pointsKey = "sessionPoints"
    private let badgesKey = "sessionBadges"
    private let lastRewardTimeKey = "lastRewardTime"
    
    init() {
        sessionHistory = FocusSessionDataManager.shared.getAllSessions()
        if let profile = ProfileDataManager.shared.getProfile() {
            self.profile = profile
        } else {
            let newProfile = Profile(name: "Mayur Kant Tyagi", image: "mayur")
            self.profile = newProfile
            ProfileDataManager.shared.createProfile(profile: newProfile)
        }
        
        restoreActiveSession()
    }
    
    deinit {
        timer?.invalidate()
    }

    private var timer: Timer?
    private let badgeOptions = ["🌵", "🎄", "🌲", "🌳", "🌴", "🍂", "🍁", "🍄", "🐅", "🦅", "🐵", "🐝"]
    private var lastRewardTime: Int = 0

    func startSession(mode: FocusMode) {
        if let selectedSession = currentSessions.filter({$0.currentMode == mode}).first{
            timerText = selectedSession.timerText
            currentMode = selectedSession.currentMode
            startTime = selectedSession.startTime
            elapsedTime = selectedSession.elapsedTime
            points = selectedSession.points
            badges = selectedSession.badges
            lastRewardTime = selectedSession.lastRewardTime
            startTimer()
//            saveActiveSessionState()
        }else{
            timerText = "00:00"
            currentMode = mode
            startTime = Date()
            elapsedTime = 0
            points = 0
            badges = []
            lastRewardTime = 0
            startTimer()
            saveActiveSessionState()
            let newSession = CurrentSessions(currentMode: currentMode)
            currentSessions.append(newSession)
        }
    }

    func stopSession() {
        timer?.invalidate()
        lastRewardTime = 0
        
        guard let start = startTime, let mode = currentMode else { return }
        let session = FocusSession(mode: mode, startTime: start, duration: elapsedTime, points: points, badges: badges)
        sessionHistory.insert(session, at: 0)
        currentMode = nil
        startTime = nil
        elapsedTime = 0
        FocusSessionDataManager.shared.createSession(focusSession: session)
        clearActiveSessionState()
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

        let currentSeconds = Int(elapsedTime)
        
        if currentSeconds >= lastRewardTime + 120 {
            points += 1
            if let badge = badgeOptions.randomElement() {
                badges.append(badge)
            }

            lastRewardTime = (currentSeconds / 120) * 120
            saveActiveSessionState()
        }
        
        if var selectedSession = currentSessions.filter({$0.currentMode == currentMode}).first{
            selectedSession.timerText = timerText
            selectedSession.currentMode = currentMode
            selectedSession.startTime = startTime
            selectedSession.elapsedTime = elapsedTime
            selectedSession.points = points
            selectedSession.badges = badges
            selectedSession.lastRewardTime = lastRewardTime
        }
        
        
    }
    
    // MARK: - App Relaunch Functionality
    
    private func saveActiveSessionState() {
        let defaults = UserDefaults.standard
        
        if let mode = currentMode, let start = startTime {
            defaults.set(true, forKey: activeSessionKey + "\(currentMode?.rawValue ?? "")")
            defaults.set(start, forKey: startTimeKey)
            defaults.set(mode.rawValue, forKey: modeKey)
            defaults.set(points, forKey: pointsKey)
            defaults.set(badges, forKey: badgesKey)
            defaults.set(lastRewardTime, forKey: lastRewardTimeKey)
        }
    }
    
    private func clearActiveSessionState() {
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: activeSessionKey + "\(currentMode?.rawValue ?? "")")
        defaults.removeObject(forKey: startTimeKey)
        defaults.removeObject(forKey: modeKey)
        defaults.removeObject(forKey: pointsKey)
        defaults.removeObject(forKey: badgesKey)
        defaults.removeObject(forKey: lastRewardTimeKey)
    }
    
    private func restoreActiveSession() {
        let defaults = UserDefaults.standard
        guard defaults.bool(forKey: activeSessionKey + "\(currentMode?.rawValue ?? "")"),
              let savedStartTime = defaults.object(forKey: startTimeKey) as? Date,
              let modeRawValue = defaults.string(forKey: modeKey),
              let mode = FocusMode(rawValue: modeRawValue) else {
            return
        }
        
        startTime = savedStartTime
        currentMode = mode
        points = defaults.integer(forKey: pointsKey)
        badges = defaults.stringArray(forKey: badgesKey) ?? []
        lastRewardTime = defaults.integer(forKey: lastRewardTimeKey)
        
        elapsedTime = Date().timeIntervalSince(savedStartTime)
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = elapsedTime >= 3600 ? [.hour, .minute, .second] : [.minute, .second]
        timerText = formatter.string(from: elapsedTime) ?? "00:00"
        
        startTimer()
        
        let currentSeconds = Int(elapsedTime)
        let missedRewardIntervals = (currentSeconds - lastRewardTime) / 120
        
        if missedRewardIntervals > 0 {
            points += missedRewardIntervals
            
            for _ in 0..<missedRewardIntervals {
                if let badge = badgeOptions.randomElement() {
                    badges.append(badge)
                }
            }
            
            lastRewardTime = (currentSeconds / 120) * 120
            
            saveActiveSessionState()
        }
    }
}


class CurrentSessions{
    var currentMode: FocusMode?
    var startTime: Date?
    var elapsedTime: TimeInterval = 0
    var points: Int = 0
    var badges: [String] = []
    var timerText: String = "00:00"
    var lastRewardTime: Int = 0
    
    init(currentMode: FocusMode?) {
        self.currentMode = currentMode
    }
}
