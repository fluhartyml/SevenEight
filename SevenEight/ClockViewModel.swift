//
//  ClockViewModel.swift
//  SevenEight
//
//  Clock state management and time formatting
//

import SwiftUI
import Combine

class ClockViewModel: ObservableObject {
    @Published var currentTime = Date()
    
    private var timer: AnyCancellable?
    
    init() {
        // Start timer
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] date in
                self?.currentTime = date
            }
    }
}
