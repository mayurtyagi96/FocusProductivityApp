//
//  ProfileView.swift
//  FocusProductivityApp
//
//  Created by Mayur Kant Tyagi on 20/04/25.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var sessionVM: FocusSessionViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                VStack(spacing: 12) {
                    Image(sessionVM.profile.image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .background(Circle().fill(Color.blue.opacity(0.2)))
                        .padding(.top)

                    Text(sessionVM.profile.name)
                        .font(.title.bold())

                    Text("Total Points: \(sessionVM.sessionHistory.reduce(0) { $0 + $1.points })")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                VStack(spacing: 16) {
                    HStack {
                        Text("🏅 Badges")
                            .font(.headline)
                        Spacer()
                    }

                    Text(sessionVM.sessionHistory.flatMap { $0.badges }.joined(separator: " "))
                        .font(.system(size: 36))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.yellow.opacity(0.1))
                        .cornerRadius(12)
                }

                VStack(spacing: 16) {
                    HStack {
                        Text("🕓 Recent Sessions")
                            .font(.headline)
                        Spacer()
                    }

                    ForEach(sessionVM.sessionHistory) { session in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(session.mode.displayName)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                Spacer()
                                Text(formatDuration(session.duration))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }

                            Text("Points Earned: \(session.points)")
                                .font(.subheadline)
                                .foregroundColor(.black)

                            Text("Start Time: \(session.formattedStartTime)")
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 14).fill(Color.white))
                        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                    }
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .scrollIndicators(.hidden)
        .scrollBounceBehavior(.basedOnSize)
    }

    func formatDuration(_ duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter.string(from: duration) ?? "--"
    }
}
