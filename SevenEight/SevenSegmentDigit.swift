//
//  SevenSegmentDigit.swift
//  SevenEight
//
//  Programmatic seven-segment LED digit display
//

import SwiftUI

struct SevenSegmentDigit: View {
    let digit: Int
    let color: Color
    let segmentWidth: CGFloat
    let segmentGap: CGFloat
    
    init(digit: Int, color: Color = .blue, segmentWidth: CGFloat = 12, segmentGap: CGFloat = 4) {
        self.digit = digit
        self.color = color
        self.segmentWidth = segmentWidth
        self.segmentGap = segmentGap
    }
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let activeSegments = segments[digit] ?? []
            
            ZStack {
                // Segment A (top)
                if activeSegments.contains(.a) {
                    HorizontalSegment()
                        .fill(color)
                        .frame(width: width - segmentGap * 2, height: segmentWidth)
                        .position(x: width / 2, y: segmentWidth / 2 + segmentGap)
                }
                
                // Segment B (top right)
                if activeSegments.contains(.b) {
                    VerticalSegment()
                        .fill(color)
                        .frame(width: segmentWidth, height: (height / 2) - segmentGap * 2)
                        .position(x: width - segmentWidth / 2 - segmentGap, y: height / 4 + segmentGap)
                }
                
                // Segment C (bottom right)
                if activeSegments.contains(.c) {
                    VerticalSegment()
                        .fill(color)
                        .frame(width: segmentWidth, height: (height / 2) - segmentGap * 2)
                        .position(x: width - segmentWidth / 2 - segmentGap, y: height * 3/4)
                }
                
                // Segment D (bottom)
                if activeSegments.contains(.d) {
                    HorizontalSegment()
                        .fill(color)
                        .frame(width: width - segmentGap * 2, height: segmentWidth)
                        .position(x: width / 2, y: height - segmentWidth / 2 - segmentGap)
                }
                
                // Segment E (bottom left)
                if activeSegments.contains(.e) {
                    VerticalSegment()
                        .fill(color)
                        .frame(width: segmentWidth, height: (height / 2) - segmentGap * 2)
                        .position(x: segmentWidth / 2 + segmentGap, y: height * 3/4)
                }
                
                // Segment F (top left)
                if activeSegments.contains(.f) {
                    VerticalSegment()
                        .fill(color)
                        .frame(width: segmentWidth, height: (height / 2) - segmentGap * 2)
                        .position(x: segmentWidth / 2 + segmentGap, y: height / 4 + segmentGap)
                }
                
                // Segment G (middle)
                if activeSegments.contains(.g) {
                    HorizontalSegment()
                        .fill(color)
                        .frame(width: width - segmentGap * 2, height: segmentWidth)
                        .position(x: width / 2, y: height / 2)
                }
            }
        }
    }
}

// MARK: - Segment Shapes

struct HorizontalSegment: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        path.move(to: CGPoint(x: height / 2, y: 0))
        path.addLine(to: CGPoint(x: width - height / 2, y: 0))
        path.addLine(to: CGPoint(x: width, y: height / 2))
        path.addLine(to: CGPoint(x: width - height / 2, y: height))
        path.addLine(to: CGPoint(x: height / 2, y: height))
        path.addLine(to: CGPoint(x: 0, y: height / 2))
        path.closeSubpath()
        
        return path
    }
}

struct VerticalSegment: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        path.move(to: CGPoint(x: width / 2, y: 0))
        path.addLine(to: CGPoint(x: width, y: width / 2))
        path.addLine(to: CGPoint(x: width, y: height - width / 2))
        path.addLine(to: CGPoint(x: width / 2, y: height))
        path.addLine(to: CGPoint(x: 0, y: height - width / 2))
        path.addLine(to: CGPoint(x: 0, y: width / 2))
        path.closeSubpath()
        
        return path
    }
}

// MARK: - Segment Definitions

enum Segment {
    case a, b, c, d, e, f, g
}

let segments: [Int: Set<Segment>] = [
    0: [.a, .b, .c, .d, .e, .f],
    1: [.b, .c],
    2: [.a, .b, .d, .e, .g],
    3: [.a, .b, .c, .d, .g],
    4: [.b, .c, .f, .g],
    5: [.a, .c, .d, .f, .g],
    6: [.a, .c, .d, .e, .f, .g],
    7: [.a, .b, .c],
    8: [.a, .b, .c, .d, .e, .f, .g],
    9: [.a, .b, .c, .d, .f, .g]
]

// MARK: - Preview

#Preview {
    HStack(spacing: 20) {
        ForEach(0..<10) { digit in
            SevenSegmentDigit(digit: digit, color: .blue)
                .frame(width: 60, height: 100)
        }
    }
    .padding()
    .background(Color.black)
}
