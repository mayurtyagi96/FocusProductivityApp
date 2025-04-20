//
//  ProfileView.swift
//  FocusProductivityApp
//
//  Created by Mayur Kant Tyagi on 20/04/25.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var sessionVM: FocusSessionViewModel
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
