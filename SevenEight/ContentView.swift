//
//  ContentView.swift
//  SevenEight
//
//  Main view showing seven-segment clock and weather forecast
//

import SwiftUI

struct ContentView: View {
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
                    color: Color.blue,
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
    }
}

#Preview {
    ContentView()
}
