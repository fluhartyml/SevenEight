//
//  ContentView.swift
//  SevenEight
//
//  Main display for seven-segment clock and weather forecast
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Upper 2/3: Seven-Segment Clock Display
                SevenSegmentClockView(time: "88:88", color: .blue, showPMDot: false)
                    .frame(maxWidth: .infinity)
                    .frame(height: UIScreen.main.bounds.height * 2/3)
                
                // Lower 1/3: Weather placeholder
                VStack(spacing: 20) {
                    Text("Weather forecast placeholder")
                        .font(.title3)
                        .foregroundColor(.blue.opacity(0.6))
                }
                .frame(maxWidth: .infinity)
                .frame(height: UIScreen.main.bounds.height * 1/3)
            }
        }
    }
}

#Preview {
    ContentView()
}
