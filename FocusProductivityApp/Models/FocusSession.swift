//
//  FocusSession.swift
//  FocusProductivityApp
//
//  Created by Mayur Kant Tyagi on 20/04/25.
//

import SwiftUI

struct FocusSession: Identifiable, Codable {
    var id = UUID()
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
