//
//  SevenSegmentClockView.swift
//  SevenEight
//
//  Seven-segment clock with colon and AM/PM indicator
//

import SwiftUI

struct SevenSegmentClockView: View {
    let time: String // Format: "HH:MM"
    let color: Color
    let showAMPM: Bool
    let isAM: Bool
    
    init(time: String = "88:88", color: Color = Color.blue, showAMPM: Bool = false, isAM: Bool = true) {
        self.time = time
        self.color = color
        self.showAMPM = showAMPM
        self.isAM = isAM
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                let digitWidth = geometry.size.width / 5.5
                let colonWidth = geometry.size.width / 8
                let digitHeight = geometry.size.height
                
                // First digit (tens of hours) - hide if 0 in 12-hour mode
                if shouldShowFirstDigit {
                    SevenSegmentDigit(digit: digit(at: 0), color: color)
                        .frame(width: digitWidth, height: digitHeight)
                } else {
                    Spacer()
                        .frame(width: digitWidth, height: digitHeight)
                }
                
                // Second digit (ones of hours)
                SevenSegmentDigit(digit: digit(at: 1), color: color)
                    .frame(width: digitWidth, height: digitHeight)
                
                // Colon (wider spacing)
                ColonView(color: color)
                    .frame(width: colonWidth, height: digitHeight)
                
                // Third digit (tens of minutes)
                SevenSegmentDigit(digit: digit(at: 2), color: color)
                    .frame(width: digitWidth, height: digitHeight)
                
                // Fourth digit (ones of minutes)
                SevenSegmentDigit(digit: digit(at: 3), color: color)
                    .frame(width: digitWidth, height: digitHeight)
                
                // AM/PM indicator (outside digits, customary position)
                if showAMPM {
                    VStack {
                        Spacer()
                        Text(isAM ? "AM" : "PM")
                            .font(.system(size: geometry.size.height * 0.2, weight: .medium, design: .monospaced))
                            .foregroundColor(color)
                            .padding(.leading, 20)
                            .padding(.bottom, geometry.size.height * 0.1)
                    }
                    .frame(height: digitHeight)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    // MARK: - Helper Properties
    
    // Hide leading zero in 12-hour mode (when showing AM/PM)
    private var shouldShowFirstDigit: Bool {
        if showAMPM {
            return digit(at: 0) != 0
        }
        return true
    }
    
    // MARK: - Clean digit extraction
    
    private func digit(at index: Int) -> Int {
        // Remove colon and extract pure digits
        let digitsOnly = time.replacingOccurrences(of: ":", with: "")
        
        // Extract digit at index: 0, 1, 2, 3
        guard index < digitsOnly.count,
              let digit = Int(String(digitsOnly[digitsOnly.index(digitsOnly.startIndex, offsetBy: index)])) else {
            return 8 // Default to 8 if parsing fails
        }
        
        return digit
    }
}

// MARK: - Colon View

struct ColonView: View {
    let color: Color
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Circle()
                .fill(color)
                .frame(width: 14, height: 14)
            Spacer()
            Circle()
                .fill(color)
                .frame(width: 14, height: 14)
            Spacer()
        }
        .padding(.vertical, 20)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 40) {
        // 12-hour with AM
        SevenSegmentClockView(time: "09:15", color: Color.blue, showAMPM: true, isAM: true)
            .frame(height: 120)
            .padding()
        
        // 12-hour with PM
        SevenSegmentClockView(time: "02:42", color: Color.red, showAMPM: true, isAM: false)
            .frame(height: 120)
            .padding()
        
        // 24-hour (no AM/PM)
        SevenSegmentClockView(time: "20:42", color: Color.green, showAMPM: false)
            .frame(height: 120)
            .padding()
    }
    .background(Color.black)
}
