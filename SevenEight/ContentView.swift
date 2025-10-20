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
    @State private var alarmSettings = AlarmSettings()
    @State private var showSettings = false
    @State private var showAlarmSettings = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Clock display - centered, taking 65% of screen
                    SevenSegmentClockView(
                        time: formattedTime,
                        color: settings.displayColor,
                        showAMPM: settings.is12Hour,
                        isAM: isAM
                    )
                    .frame(height: geometry.size.height * 0.65)
                    
                    // 7-day forecast - centered at bottom
                    HStack {
                        Spacer()
                        HStack(spacing: 30) {
                            if let forecast = weatherViewModel.dailyForecast, !forecast.isEmpty {
                                ForEach(Array(forecast.prefix(7).enumerated()), id: \.element.date) { index, day in
                                    VStack(spacing: 8) {
                                        // Day name
                                        Text(dayLabel(for: day.date, index: index))
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(settings.displayColor)
                                        
                                        // Weather icon
                                        Image(systemName: day.symbolName)
                                            .font(.system(size: 32))
                                            .foregroundColor(settings.displayColor)
                                        
                                        // High temp
                                        Text("\(convertTemp(day.highTemperature.value))°")
                                            .font(.system(size: 20, weight: .semibold))
                                            .foregroundColor(settings.displayColor)
                                        
                                        // Low temp
                                        Text("\(convertTemp(day.lowTemperature.value))°")
                                            .font(.system(size: 18, weight: .regular))
                                            .foregroundColor(settings.displayColor.opacity(0.6))
                                    }
                                    .frame(width: 90)
                                }
                            } else {
                                Text("Loading forecast...")
                                    .font(.system(size: 16))
                                    .foregroundColor(settings.displayColor.opacity(0.6))
                            }
                        }
                        Spacer()
                    }
                    .frame(height: geometry.size.height * 0.3)
                    
                    // Alarm indicators - below forecast
                    HStack(spacing: 40) {
                        ForEach(alarmSettings.enabledAlarmIndicators, id: \.self) { indicator in
                            Text(indicator)
                                .font(.system(size: 20, weight: .medium, design: .monospaced))
                                .foregroundColor(settings.displayColor.opacity(0.8))
                        }
                    }
                    .frame(height: geometry.size.height * 0.05)
                }
                
                // Settings button - bottom left (app settings)
                VStack {
                    Spacer()
                    HStack {
                        Button(action: { showSettings = true }) {
                            Image(systemName: "gearshape")
                                .font(.system(size: 24))
                                #if os(tvOS)
                                .foregroundColor(.gray.opacity(0.5))
                                #else
                                .foregroundColor(settings.displayColor.opacity(0.3))
                                #endif
                                .padding(20)
                        }
                        #if os(tvOS)
                        .buttonStyle(.plain)
                        .background(Color.clear)
                        .focusEffectDisabled()
                        #else
                        .buttonStyle(.plain)
                        #endif
                        
                        Spacer()
                        
                        // Alarm settings button - bottom right
                        Button(action: { showAlarmSettings = true }) {
                            Image(systemName: "alarm")
                                .font(.system(size: 24))
                                #if os(tvOS)
                                .foregroundColor(.gray.opacity(0.5))
                                #else
                                .foregroundColor(settings.displayColor.opacity(0.3))
                                #endif
                                .padding(20)
                        }
                        #if os(tvOS)
                        .buttonStyle(.plain)
                        .background(Color.clear)
                        .focusEffectDisabled()
                        #else
                        .buttonStyle(.plain)
                        #endif
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView(settings: settings)
            }
            .sheet(isPresented: $showAlarmSettings) {
                AlarmSettingsView(alarmSettings: alarmSettings)
            }
        }
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Temperature Conversion
    
    private func convertTemp(_ celsius: Double) -> Int {
        if settings.isFahrenheit {
            return Int((celsius * 9/5) + 32)
        }
        return Int(celsius)
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
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
}

#Preview {
    ContentView()
}
