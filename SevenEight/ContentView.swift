//
//  ContentView.swift
//  SevenEight
//
//  Main view showing seven-segment clock and weather forecast
//

import SwiftUI

struct ContentView: View {
    @StateObject private var settings = AppSettings()
    @State private var showSettings = false
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top spacer for margin
                Spacer()
                    .frame(height: 60)
                
                // Clock Display (upper 2/3)
                SevenSegmentClockView(
                    time: "88:88",
                    color: settings.displayColor,
                    showPMDot: false
                )
                .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
                
                Spacer()
                
                // Weather Placeholder (lower 1/3)
                Text("Weather Forecast")
                    .foregroundColor(Color.white.opacity(0.3))
                    .font(.title2)
                
                Spacer()
            }
        }
        // iPhone: Swipe down to open settings
        .gesture(
            DragGesture()
                .onEnded { gesture in
                    if gesture.translation.height > 50 {
                        showSettings = true
                    }
                }
        )
        // Apple TV: Any button press opens settings
        #if os(tvOS)
        .onPlayPauseCommand {
            showSettings = true
        }
        .onMenuCommand {
            showSettings = true
        }
        #endif
        .sheet(isPresented: $showSettings) {
            SettingsView(settings: settings)
        }
    }
}

#Preview {
    ContentView()
}
