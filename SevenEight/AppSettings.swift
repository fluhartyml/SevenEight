//
//  AppSettings.swift
//  SevenEight
//
//  App settings with persistent storage
//

import SwiftUI
import Combine

class AppSettings: ObservableObject {
    // Color selection for seven-segment display
    @AppStorage("segmentColor") var segmentColor: String = "blue"
    
    // Temperature unit preference
    @AppStorage("temperatureUnit") var temperatureUnit: String = "fahrenheit"
    
    // Time format preference
    @AppStorage("timeFormat") var timeFormat: String = "24hour"
    
    // Manual location override for weather
    @AppStorage("manualCity") var manualCity: String = ""
    
    // Convert color string to SwiftUI Color
    var displayColor: Color {
        switch segmentColor {
        case "blue":
            return Color.blue
        case "white":
            return Color.white
        case "yellow":
            return Color.yellow
        case "red":
            return Color.red
        default:
            return Color.blue
        }
    }
    
    // Check if using 12-hour format
    var is12Hour: Bool {
        return timeFormat == "12hour"
    }
    
    // Check if using Fahrenheit
    var isFahrenheit: Bool {
        return temperatureUnit == "fahrenheit"
    }
}
