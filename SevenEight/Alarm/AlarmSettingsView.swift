//
//  AlarmSettingsView.swift
//  SevenEight
//
//  Alarm configuration interface for dual alarms
//

import SwiftUI

struct AlarmSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var alarmSettings: AlarmSettings
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 60) {
                    Text("Alarm Settings")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 40)
                    
                    // Alarm 1
                    AlarmConfigView(alarm: $alarmSettings.alarm1, alarmNumber: 1)
                    
                    Divider()
                        .background(Color.white.opacity(0.3))
                        .padding(.horizontal, 40)
                    
                    // Alarm 2
                    AlarmConfigView(alarm: $alarmSettings.alarm2, alarmNumber: 2)
                    
                    // Done button
                    Button(action: {
                        alarmSettings.saveAll()
                        dismiss()
                    }) {
                        Text("Done")
                            .font(.system(size: 32, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 300, height: 80)
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 20)
                    .padding(.bottom, 60)
                }
            }
        }
    }
}

struct AlarmConfigView: View {
    @Binding var alarm: Alarm
    let alarmNumber: Int
    
    let dayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var body: some View {
        VStack(spacing: 30) {
            // Alarm header with toggle
            HStack {
                Text("ALARM \(alarmNumber)")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Toggle("", isOn: $alarm.isEnabled)
                    .labelsHidden()
                    .scaleEffect(1.5)
            }
            .padding(.horizontal, 60)
            
            if alarm.isEnabled {
                // Time picker - using inline style for tvOS
                HStack(spacing: 20) {
                    Text("Time:")
                        .font(.system(size: 28))
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    // Hour picker
                    Picker("Hour", selection: $alarm.hour) {
                        ForEach(0..<100) { hour in
                            Text(String(format: "%02d", hour))
                                .font(.system(size: 28, design: .monospaced))
                                .tag(hour)
                        }
                    }
                    .pickerStyle(.automatic)
                    .frame(width: 150)
                    
                    Text(":")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                    
                    // Minute picker
                    Picker("Minute", selection: $alarm.minute) {
                        ForEach(0..<100) { minute in
                            Text(String(format: "%02d", minute))
                                .font(.system(size: 28, design: .monospaced))
                                .tag(minute)
                        }
                    }
                    .pickerStyle(.automatic)
                    .frame(width: 150)
                }
                .padding(.horizontal, 60)
                
                // Days of week
                VStack(alignment: .leading, spacing: 15) {
                    Text("Days:")
                        .font(.system(size: 28))
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 20) {
                        ForEach(0..<7) { index in
                            Button(action: {
                                alarm.daysEnabled[index].toggle()
                            }) {
                                Text(dayNames[index])
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundColor(alarm.daysEnabled[index] ? .black : .white)
                                    .frame(width: 80, height: 60)
                                    .background(alarm.daysEnabled[index] ? Color.white : Color.clear)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.white, lineWidth: 2)
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, 60)
                
                // Music selection
                HStack {
                    Text("Music:")
                        .font(.system(size: 28))
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(alarm.musicPlaylistName ?? "None selected")
                        .font(.system(size: 24))
                        .foregroundColor(.white.opacity(0.8))
                    
                    Button(action: {
                        // TODO: Show music picker
                    }) {
                        Text("Choose")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 15)
                            .background(Color.blue.opacity(0.8))
                            .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 60)
                
                // Volume - use buttons instead of slider for tvOS
                HStack {
                    Text("Volume:")
                        .font(.system(size: 28))
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Button(action: {
                        alarm.volume = max(0, alarm.volume - 0.1)
                    }) {
                        Image(systemName: "minus.circle")
                            .font(.system(size: 32))
                            .foregroundColor(.white)
                    }
                    .buttonStyle(.plain)
                    
                    Text("\(Int(alarm.volume * 100))%")
                        .font(.system(size: 28, design: .monospaced))
                        .foregroundColor(.white)
                        .frame(width: 100)
                    
                    Button(action: {
                        alarm.volume = min(1, alarm.volume + 0.1)
                    }) {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 32))
                            .foregroundColor(.white)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 60)
                
                // Fade-in toggle
                HStack {
                    Text("Fade-in:")
                        .font(.system(size: 28))
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Toggle("", isOn: $alarm.fadeInEnabled)
                        .labelsHidden()
                        .scaleEffect(1.3)
                }
                .padding(.horizontal, 60)
                
                // Snooze duration
                HStack {
                    Text("Snooze Duration:")
                        .font(.system(size: 28))
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Picker("Minutes", selection: $alarm.snoozeDuration) {
                        ForEach([5, 10, 15, 20, 30], id: \.self) { minutes in
                            Text("\(minutes) min")
                                .font(.system(size: 24))
                                .tag(minutes)
                        }
                    }
                    .pickerStyle(.automatic)
                }
                .padding(.horizontal, 60)
            }
        }
    }
}

#Preview {
    AlarmSettingsView(alarmSettings: AlarmSettings())
}
