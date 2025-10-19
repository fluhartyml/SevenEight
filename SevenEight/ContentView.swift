//
//  ContentView.swift
//  SevenEight
//
//  Main view showing seven-segment clock and weather forecast
//

import SwiftUI
import Combine

struct ContentView: View {
    @StateObject private var settings = AppSettings()
    @State private var showSettings = false
    @State private var currentDate = Date()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
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
                    time: formattedTime,
                    color: settings.displayColor,
                    showAMPM: settings.is12Hour,
                    isAM: isAM
                )
                .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
                
                Spacer()
                
                // DEBUG
                Text("DEBUG: \(formattedTime)")
                    .foregroundColor(Color.yellow)
                
                // Weather Placeholder (lower 1/3)
                Text(settings.manualCity.isEmpty ? "Weather Forecast" : settings.manualCity)
                    .foregroundColor(Color.white.opacity(0.3))
                    .font(.title2)
                
                Spacer()
            }
        }
        .gesture(
            DragGesture()
                .onEnded { gesture in
                    if gesture.translation.height > 50 {
                        showSettings = true
                    }
                }
        )
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
        .onReceive(timer) { _ in
            currentDate = Date()
        }
    }
    
    private var formattedTime: String {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: currentDate)
        let minute = calendar.component(.minute, from: currentDate)
        
        // Manual 12/24 hour conversion using circular clock math
        let displayHour = settings.is12Hour ? ((hour - 1) % 12) + 1 : hour
        
        return String(format: "%02d:%02d", displayHour, minute)
    }
    
    private var isAM: Bool {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: currentDate)
        return hour < 12
    }
}

#Preview {
    ContentView()
}
