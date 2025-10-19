//
//  SevenSegmentClockView.swift
//  SevenEight
//
//  Bare-bones seven-segment clock - digits only
//

import SwiftUI

struct SevenSegmentClockView: View {
    let time: String // Format: "HH:MM"
    let color: Color
    
    init(time: String = "88:88", color: Color = Color.blue) {
        self.time = time
        self.color = color
    }
    
    var body: some View {
        GeometryReader { geometry in
            let digitWidth = geometry.size.width / 4
            let digitHeight = geometry.size.height
            
            HStack(spacing: 0) {
                // First digit (tens of hours)
                SevenSegmentDigit(digit: digit(at: 0), color: color)
                    .frame(width: digitWidth, height: digitHeight)
                
                // Second digit (ones of hours)
                SevenSegmentDigit(digit: digit(at: 1), color: color)
                    .frame(width: digitWidth, height: digitHeight)
                
                // Third digit (tens of minutes)
                SevenSegmentDigit(digit: digit(at: 2), color: color)
                    .frame(width: digitWidth, height: digitHeight)
                
                // Fourth digit (ones of minutes)
                SevenSegmentDigit(digit: digit(at: 3), color: color)
                    .frame(width: digitWidth, height: digitHeight)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
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

// MARK: - Preview

#Preview {
    VStack(spacing: 40) {
        SevenSegmentClockView(time: "12:34", color: Color.blue)
            .frame(height: 120)
            .padding()
        
        SevenSegmentClockView(time: "20:34", color: Color.red)
            .frame(height: 120)
            .padding()
    }
    .background(Color.black)
}
