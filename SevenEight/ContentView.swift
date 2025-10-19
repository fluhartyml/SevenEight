//
//  ContentView.swift
//  SevenEight
//
//  Seven-segment clock with current weather and 7-day forecast
//

import SwiftUI
import WeatherKit

struct ContentView: View {
    @StateObject private var clockViewModel = ClockViewModel()
    @StateObject private var settings = AppSettings()
    @State private var weatherViewModel = WeatherViewModel()
    @State private var showSettings = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Clock display - top 60%
                    SevenSegmentClockView(
                        time: formattedTime,
                        color: settings.displayColor,
                        showAMPM: settings.is12Hour,
                        isAM: isAM
                    )
                    .frame(height: geometry.size.height * 0.6)
                    
                    // Weather section - bottom 40%
                    VStack(spacing: 20) {
                        // Current weather - top
                        HStack(spacing: 12) {
                            if let weather = weatherViewModel.currentWeather {
                                Image(systemName: weather.symbolName)
                                    .font(.system(size: 50))
                                    .foregroundColor(.white)
                                
                                Text("\(Int(weather.temperature.value))°")
                                    .font(.system(size: 40, weight: .light))
                                    .foregroundColor(.white)
                                
                                Text(weather.condition.description.capitalized)
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                                
                                Text("Current Location")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray.opacity(0.7))
                            } else if let error = weatherViewModel.weatherError {
                                Text("Unable to fetch weather")
                                    .font(.system(size: 14))
                                    .foregroundColor(.red)
                            } else {
                                ProgressView()
                                    .tint(.white)
                            }
                        }
                        
                        // 7-day forecast - horizontal scroll
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                if let forecast = weatherViewModel.dailyForecast, !forecast.isEmpty {
                                    ForEach(Array(forecast.prefix(7).enumerated()), id: \.element.date) { index, day in
                                        VStack(spacing: 8) {
                                            // Day name
                                            Text(dayLabel(for: day.date, index: index))
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(.white)
                                            
                                            // Weather icon
                                            Image(systemName: day.symbolName)
                                                .font(.system(size: 28))
                                                .foregroundColor(.white)
                                            
                                            // High/Low temps
                                            VStack(spacing: 2) {
                                                Text("\(Int(day.highTemperature.value))°")
                                                    .font(.system(size: 18, weight: .semibold))
                                                    .foregroundColor(.white)
                                                
                                                Text("\(Int(day.lowTemperature.value))°")
                                                    .font(.system(size: 16, weight: .regular))
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                        .frame(width: 80)
                                    }
                                } else {
                                    Text("Loading forecast...")
                                        .font(.system(size: 16))
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .frame(height: geometry.size.height * 0.4)
                    .padding(.horizontal, 20)
                }
                
                // Settings button - more visible
                VStack {
                    HStack {
                        Spacer()
                        Button(action: { showSettings = true }) {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.white.opacity(0.6))
                                .padding(20)
                        }
                    }
                    Spacer()
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView(settings: settings)
            }
        }
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Time Formatting
    
    private var formattedTime: String {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: clockViewModel.currentTime)
        let minute = calendar.component(.minute, from: clockViewModel.currentTime)
        
        if settings.is12Hour {
            let displayHour = ((hour - 1) % 12) + 1
            // Always pass 4 digits, let SevenSegmentClockView handle leading zero
            return String(format: "%02d:%02d", displayHour, minute)
        } else {
            return String(format: "%02d:%02d", hour, minute)
        }
    }
    
    private var isAM: Bool {
        let hour = Calendar.current.component(.hour, from: clockViewModel.currentTime)
        return hour < 12
    }
    
    private func dayLabel(for date: Date, index: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE" // Full day name: Monday, Tuesday, etc.
        return formatter.string(from: date)
    }
}

#Preview {
    ContentView()
}
