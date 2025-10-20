//
//  Alarm.swift
//  SevenEight
//
//  Alarm data model for dual alarm system
//

import Foundation
import MusicKit

struct Alarm: Codable, Identifiable {
    let id: Int // 1 or 2
    var isEnabled: Bool
    var hour: Int // 0-23
    var minute: Int // 0-59
    var daysEnabled: [Bool] // 7 days: Sun, Mon, Tue, Wed, Thu, Fri, Sat
    var musicPlaylistID: String?
    var musicPlaylistName: String?
    var volume: Double // 0.0 to 1.0
    var fadeInEnabled: Bool
    var snoozeDuration: Int // minutes
    
    init(id: Int) {
        self.id = id
        self.isEnabled = false
        self.hour = 7
        self.minute = 0
        self.daysEnabled = [false, true, true, true, true, true, false] // Weekdays default
        self.musicPlaylistID = nil
        self.musicPlaylistName = "None selected"
        self.volume = 0.7
        self.fadeInEnabled = true
        self.snoozeDuration = 15
    }
    
    // Format time as HH:MM
    var timeString: String {
        String(format: "%02d:%02d", hour, minute)
    }
    
    // Check if this is the magic 99:99 easter egg
    var isMusicPlayerMode: Bool {
        return hour == 99 && minute == 99
    }
    
    // Get enabled days as string
    var enabledDaysString: String {
        let dayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        let enabled = daysEnabled.enumerated()
            .filter { $0.element }
            .map { dayNames[$0.offset] }
        
        if enabled.isEmpty {
            return "Never"
        } else if enabled.count == 7 {
            return "Every day"
        } else if enabled == ["Mon", "Tue", "Wed", "Thu", "Fri"] {
            return "Weekdays"
        } else if enabled == ["Sat", "Sun"] {
            return "Weekends"
        } else {
            return enabled.joined(separator: ", ")
        }
    }
}
