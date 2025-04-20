//
//  FocusMode.swift
//  FocusProductivityApp
//
//  Created by Mayur Kant Tyagi on 20/04/25.
//

enum FocusMode: String, CaseIterable, Identifiable, Codable {
    case work, play, rest, sleep

    var id: String { self.rawValue }
    var displayName: String { self.rawValue.capitalized }
}
