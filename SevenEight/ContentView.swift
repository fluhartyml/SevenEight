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
                    HStack(alignment: .top, spacing: 40) {
                        // Current weather - left side
                        VStack(spacing: 8) {
                            if let weather = weatherViewModel.currentWeather {
                                Image(systemName: weather.symbolName)
                                    .font(.system(size: 60))
                                    .foregroundColor(.white)
                                
                                Text("\(Int(weather.temperature.value))°")
                                    .font(.system(size: 48, weight: .light))
                                    .foregroundColor(.white)
                                
                                Text(weather.condition.description.capitalized)
                                    .font(.system(size: 18))
                                    .foregroundColor(.gray)
                                
                                Text("Current Location")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray.opacity(0.7))
                            } else if let error = weatherViewModel.weatherError {
                                Text("Unable to fetch weather")
                                    .font(.system(size: 16))
                                    .foregroundColor(.red)
                                Text(error)
                                    .font(.system(size: 12))
                                    .foregroundColor(.red.opacity(0.7))
                                    .multilineTextAlignment(.center)
                            } else {
                                ProgressView()
                                    .tint(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        // 7-day forecast - right side
                        VStack(alignment: .leading, spacing: 12) {
                            if let forecast = weatherViewModel.dailyForecast, !forecast.isEmpty {
                                ForEach(Array(forecast.prefix(7).enumerated()), id: \.element.date) { index, day in
                                    HStack(spacing: 16) {
                                        // Day name
                                        Text(dayLabel(for: day.date, index: index))
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(.white)
                                            .frame(width: 70, alignment: .leading)
                                        
                                        // Weather icon
                                        Image(systemName: day.symbolName)
                                            .font(.system(size: 24))
                                            .foregroundColor(.white)
                                            .frame(width: 30)
                                        
                                        // High/Low temps
                                        HStack(spacing: 4) {
                                            Text("\(Int(day.highTemperature.value))°")
                                                .font(.system(size: 18, weight: .semibold))
                                                .foregroundColor(.white)
                                            
                                            Text("/")
                                                .font(.system(size: 18))
                                                .foregroundColor(.gray)
                                            
                                            Text("\(Int(day.lowTemperature.value))°")
                                                .font(.system(size: 18, weight: .regular))
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                            } else {
                                Text("Loading forecast...")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                    }
                    .frame(height: geometry.size.height * 0.4)
                    .padding(.horizontal, 40)
                }
                
                // Settings button
                VStack {
                    HStack {
                        Spacer()
                        Button(action: { showSettings = true }) {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.gray.opacity(0.3))
                                .padding()
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
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInTomorrow(date) {
            return "Tomorrow"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE" // Mon, Tue, Wed, etc.
            return formatter.string(from: date)
        }
    }
}

#Preview {
    ContentView()
}
