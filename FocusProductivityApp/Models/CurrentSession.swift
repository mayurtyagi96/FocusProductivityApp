//
//  CurrentSession.swift
//  FocusProductivityApp
//
//  Created by Mayur Kant Tyagi on 29/04/25.
//
import SwiftUI

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
