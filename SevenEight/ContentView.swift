//
//  ContentView.swift
//  SevenEight
//
//  Main display for seven-segment clock and weather forecast
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 30) {
            // Seven-segment display placeholder
            Text("88:88")
                .font(.system(size: 100, weight: .bold, design: .monospaced))
                .foregroundColor(.primary)
            
            // Bundle ID
            Text("com.MLF.SevenEight")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Divider()
                .padding(.horizontal, 40)
            
            // App description
            VStack(spacing: 12) {
                Text("Seven-Segment Digital Clock")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Nightstand clock with 7-day weather forecast")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
