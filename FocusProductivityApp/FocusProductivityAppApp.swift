//
//  FocusProductivityAppApp.swift
//  FocusProductivityApp
//
//  Created by Mayur Kant Tyagi on 20/04/25.
//

import SwiftUI

@main
struct FocusProductivityApp: App {
    @StateObject private var sessionVM = FocusSessionViewModel()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView(sessionVM: sessionVM)
            }
        }
    }
}
