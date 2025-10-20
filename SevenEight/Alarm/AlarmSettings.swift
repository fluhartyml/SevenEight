//
//  AlarmSettings.swift
//  SevenEight
//
//  Persistent storage for alarm configurations
//

import Foundation
import SwiftUI

@Observable
class AlarmSettings {
    var alarm1: Alarm
    var alarm2: Alarm
    
    private let alarm1Key = "alarm1_settings"
    private let alarm2Key = "alarm2_settings"
    
    init() {
        // Load saved alarms or create defaults
        if let data1 = UserDefaults.standard.data(forKey: alarm1Key),
           let savedAlarm1 = try? JSONDecoder().decode(Alarm.self, from: data1) {
            self.alarm1 = savedAlarm1
        } else {
            self.alarm1 = Alarm(id: 1)
        }
        
        if let data2 = UserDefaults.standard.data(forKey: alarm2Key),
           let savedAlarm2 = try? JSONDecoder().decode(Alarm.self, from: data2) {
            self.alarm2 = savedAlarm2
        } else {
            self.alarm2 = Alarm(id: 2)
        }
    }
    
    // Save alarm 1
    func saveAlarm1() {
        if let encoded = try? JSONEncoder().encode(alarm1) {
            UserDefaults.standard.set(encoded, forKey: alarm1Key)
        }
    }
    
    // Save alarm 2
    func saveAlarm2() {
        if let encoded = try? JSONEncoder().encode(alarm2) {
            UserDefaults.standard.set(encoded, forKey: alarm2Key)
        }
    }
    
    // Save both alarms
    func saveAll() {
        saveAlarm1()
        saveAlarm2()
    }
    
    // Check if either alarm is set to 99:99 (music player easter egg)
    var isMusicPlayerMode: Bool {
        return alarm1.isMusicPlayerMode || alarm2.isMusicPlayerMode
    }
    
    // Get array of enabled alarms for display
    var enabledAlarmIndicators: [String] {
        var indicators: [String] = []
        if alarm1.isEnabled {
            indicators.append("ALARM 1")
        }
        if alarm2.isEnabled {
            indicators.append("ALARM 2")
        }
        return indicators
    }
}
