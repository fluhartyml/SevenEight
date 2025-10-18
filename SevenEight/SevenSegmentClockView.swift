//
//  SevenSegmentClockView.swift
//  SevenEight
//
//  Seven-segment LED clock display with colon
//

import SwiftUI

struct SevenSegmentClockView: View {
    let time: String // Format: "HH:MM"
    let color: Color
    let showPMDot: Bool
    
    init(time: String = "88:88", color: Color = .blue, showPMDot: Bool = false) {
        self.time = time
        self.color = color
        self.showPMDot = showPMDot
    }
    
    var body: some View {
        GeometryReader { geometry in
            let digitWidth = geometry.size.width / 6
            let digitHeight = geometry.size.height
            
            HStack(spacing: 0) {
                // First digit (tens of hours)
                SevenSegmentDigit(digit: digit(at: 0), color: color)
                    .frame(width: digitWidth, height: digitHeight)
                
                // Second digit (ones of hours)
                SevenSegmentDigit(digit: digit(at: 1), color: color)
                    .frame(width: digitWidth, height: digitHeight)
                
                // Colon
                ColonView(color: color)
                    .frame(width: digitWidth * 0.5, height: digitHeight)
                
                // Third digit (tens of minutes)
                SevenSegmentDigit(digit: digit(at: 3), color: color)
                    .frame(width: digitWidth, height: digitHeight)
                
                // Fourth digit (ones of minutes)
                SevenSegmentDigit(digit: digit(at: 4), color: color)
                    .frame(width: digitWidth, height: digitHeight)
                
                // PM dot
                if showPMDot {
                    PMDotView(color: color)
                        .frame(width: digitWidth * 0.5, height: digitHeight)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    private func digit(at index: Int) -> Int {
        let cleaned = time.replacingOccurrences(of: ":", with: "")
        guard index < cleaned.count,
              let digit = Int(String(cleaned[cleaned.index(cleaned.startIndex, offsetBy: index)])) else {
            return 8
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
                .frame(width: 12, height: 12)
            Spacer()
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            Spacer()
        }
        .padding(.vertical, 20)
    }
}

// MARK: - PM Dot View

struct PMDotView: View {
    let color: Color
    
    var body: some View {
        VStack {
            Spacer()
            Circle()
                .fill(color)
                .frame(width: 16, height: 16)
                .padding(.bottom, 8)
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 40) {
        SevenSegmentClockView(time: "12:34", color: .blue, showPMDot: false)
            .frame(height: 120)
            .padding()
        
        SevenSegmentClockView(time: "08:45", color: .red, showPMDot: true)
            .frame(height: 120)
            .padding()
    }
    .background(Color.black)
}
