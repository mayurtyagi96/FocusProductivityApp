//
//  HomeView.swift
//  FocusProductivityApp
//
//  Created by Mayur Kant Tyagi on 20/04/25.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var sessionVM: FocusSessionViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("Select Focus Mode")
                .font(.title)

            ForEach(FocusMode.allCases) { mode in
                NavigationLink(destination: FocusModeView(mode: mode, sessionVM: sessionVM)) {
                    Text(mode.displayName)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(12)
                }
            }

            NavigationLink("Go to Profile", destination: ProfileView(sessionVM: sessionVM))
                .padding(.top, 40)
        }
        .padding()
    }
}
