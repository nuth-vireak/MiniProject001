//
//  ContentView.swift
//  MiniProject001
//
//  Created by KAK-REAK on 18/9/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
                    .navigationTitle("Articles")
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            
            NavigationStack {
                PostView()
                    .navigationTitle("Post Article")
            }
            .tabItem {
                Label("Post", systemImage: "plus.app")
            }
            
            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Label("Profile", systemImage: "person")
            }
        }
    }
}

#Preview {
    ContentView()
}
