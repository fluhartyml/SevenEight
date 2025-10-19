//
//  ContentView.swift
//  SevenEight
//
//  Main view showing seven-segment clock and weather forecast
//

import SwiftUI
import Combine
import WeatherKit
import CoreLocation

struct ContentView: View {
    @StateObject private var settings = AppSettings()
    @StateObject private var weatherViewModel = WeatherViewModel()
    @StateObject private var locationManager = LocationManager()
    
    @State private var showSettings = false
    @State private var currentDate = Date()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
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
                    time: formattedTime,
                    color: settings.displayColor,
                    showAMPM: settings.is12Hour,
                    isAM: isAM
                )
                .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
                
                Spacer()
                
                // Weather Display
                weatherDisplay
                
                Spacer()
            }
        }
        .gesture(
            DragGesture()
                .onEnded { gesture in
                    if gesture.translation.height > 50 {
                        showSettings = true
                    }
                }
        )
        #if os(tvOS)
        .onPlayPauseCommand {
            showSettings = true
        }
        .onMenuCommand {
            showSettings = true
        }
        #endif
        .sheet(isPresented: $showSettings) {
            SettingsView(settings: settings)
        }
        .onReceive(timer) { _ in
            currentDate = Date()
        }
        .task {
            locationManager.requestPermission()
        }
        .onChange(of: locationManager.location) { oldValue, newValue in
            if let location = newValue {
                Task {
                    await weatherViewModel.fetchWeather(for: location, useFahrenheit: settings.isFahrenheit)
                }
            }
        }
        .onChange(of: settings.manualCity) { oldValue, newValue in
            if !newValue.isEmpty, let location = locationManager.location {
                Task {
                    await weatherViewModel.fetchWeather(for: location, useFahrenheit: settings.isFahrenheit)
                }
            }
        }
    }
    
    @ViewBuilder
    private var weatherDisplay: some View {
        if weatherViewModel.isLoading {
            ProgressView()
                .tint(.white)
        } else if let error = weatherViewModel.errorMessage {
            Text(error)
                .foregroundColor(Color.red.opacity(0.6))
                .font(.caption)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        } else if let temperature = weatherViewModel.temperature,
                  let condition = weatherViewModel.condition {
            VStack(spacing: 8) {
                // Temperature
                Text(temperature)
                    .foregroundColor(Color.white.opacity(0.8))
                    .font(.system(size: 48, weight: .light, design: .rounded))
                
                // Condition
                Text(condition)
                    .foregroundColor(Color.white.opacity(0.6))
                    .font(.title3)
                
                // Location
                if !settings.manualCity.isEmpty {
                    Text(settings.manualCity)
                        .foregroundColor(Color.white.opacity(0.4))
                        .font(.caption)
                } else {
                    Text("Current Location")
                        .foregroundColor(Color.white.opacity(0.4))
                        .font(.caption)
                }
            }
        } else {
            Text("Weather Forecast")
                .foregroundColor(Color.white.opacity(0.3))
                .font(.title2)
        }
    }
    
    private var formattedTime: String {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: currentDate)
        let minute = calendar.component(.minute, from: currentDate)
        
        // Manual 12/24 hour conversion using circular clock math
        let displayHour = settings.is12Hour ? ((hour - 1) % 12) + 1 : hour
        
        return String(format: "%02d:%02d", displayHour, minute)
    }
    
    private var isAM: Bool {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: currentDate)
        return hour < 12
    }
}

// MARK: - Location Manager

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    }
    
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        
        switch authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
}

// MARK: - Weather ViewModel

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var temperature: String?
    @Published var condition: String?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let weatherService = WeatherService.shared
    
    func fetchWeather(for location: CLLocation, useFahrenheit: Bool) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let weather = try await weatherService.weather(for: location)
            let currentWeather = weather.currentWeather
            
            // Format temperature
            let unit = useFahrenheit ? UnitTemperature.fahrenheit : UnitTemperature.celsius
            let temp = currentWeather.temperature.converted(to: unit)
            temperature = String(format: "%.0f°", temp.value)
            
            // Get condition description
            condition = currentWeather.condition.description
            
            isLoading = false
        } catch {
            errorMessage = "Unable to fetch weather"
            isLoading = false
            print("Weather fetch error: \(error)")
        }
    }
}

#Preview {
    ContentView()
}
