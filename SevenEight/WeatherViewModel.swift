//
//  WeatherViewModel.swift
//  SevenEight
//
//  WeatherKit integration and forecast management
//

import SwiftUI
import WeatherKit
import CoreLocation

@MainActor
@Observable
class WeatherViewModel {
    var currentWeather: CurrentWeather?
    var dailyForecast: [DayWeather]?
    var weatherError: String?
    
    private let weatherService = WeatherService.shared
    private let locationManager = CLLocationManager()
    
    init() {
        Task {
            await requestLocationAndFetchWeather()
        }
    }
    
    func requestLocationAndFetchWeather() async {
        // Request location authorization
        locationManager.requestWhenInUseAuthorization()
        
        // Get current location
        guard let location = locationManager.location else {
            weatherError = "Location unavailable"
            return
        }
        
        await fetchWeather(for: location)
    }
    
    func fetchWeather(for location: CLLocation) async {
        do {
            // Fetch current weather
            let weather = try await weatherService.weather(for: location)
            currentWeather = weather.currentWeather
            
            // Fetch daily forecast
            let forecast = try await weatherService.weather(
                for: location,
                including: .daily
            )
            dailyForecast = Array(forecast)
            
            weatherError = nil
        } catch {
            weatherError = error.localizedDescription
            print("Weather fetch error: \(error)")
        }
    }
    
    func refresh() async {
        guard let location = locationManager.location else {
            weatherError = "Location unavailable"
            return
        }
        await fetchWeather(for: location)
    }
}
