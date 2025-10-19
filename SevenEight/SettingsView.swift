//
//  SettingsView.swift
//  SevenEight
//
//  Settings interface for clock customization
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings: AppSettings
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                // Color Selection
                Section(header: Text("Display Color")) {
                    Picker("Segment Color", selection: $settings.segmentColor) {
                        Text("Blue").tag("blue")
                        Text("White").tag("white")
                        Text("Yellow").tag("yellow")
                        Text("Red").tag("red")
                    }
                    .pickerStyle(.segmented)
                }
                
                // Temperature Unit
                Section(header: Text("Temperature")) {
                    Picker("Unit", selection: $settings.temperatureUnit) {
                        Text("°F").tag("fahrenheit")
                        Text("°C").tag("celsius")
                    }
                    .pickerStyle(.segmented)
                }
                
                // Time Format
                Section(header: Text("Time Format")) {
                    Picker("Format", selection: $settings.timeFormat) {
                        Text("12 Hour").tag("12hour")
                        Text("24 Hour").tag("24hour")
                    }
                    .pickerStyle(.segmented)
                }
                
                // Manual Location Override
                Section(header: Text("Weather Location")) {
                    TextField("City Name", text: $settings.manualCity)
                        .textInputAutocapitalization(.words)
                    
                    Text("Leave blank to use current location")
                        .font(.caption)
                        .foregroundColor(Color.gray)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView(settings: AppSettings())
}
