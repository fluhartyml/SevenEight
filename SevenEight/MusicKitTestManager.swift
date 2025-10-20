//
//  MusicKitTestManager.swift
//  SevenEight
//
//  Test MusicKit authorization and basic functionality
//

import Foundation
import MusicKit

@Observable
class MusicKitTestManager {
    var authorizationStatus: MusicAuthorization.Status = .notDetermined
    var isAuthorized: Bool = false
    var statusMessage: String = "Not checked yet"
    var errorMessage: String?
    
    init() {
        checkCurrentStatus()
    }
    
    // Check current authorization status without prompting
    func checkCurrentStatus() {
        authorizationStatus = MusicAuthorization.currentStatus
        isAuthorized = (authorizationStatus == .authorized)
        
        switch authorizationStatus {
        case .notDetermined:
            statusMessage = "Not yet requested"
        case .denied:
            statusMessage = "User denied access"
        case .restricted:
            statusMessage = "Access restricted (parental controls?)"
        case .authorized:
            statusMessage = "Authorized! ✅"
        @unknown default:
            statusMessage = "Unknown status"
        }
    }
    
    // Request authorization from user
    func requestAuthorization() async {
        let status = await MusicAuthorization.request()
        
        authorizationStatus = status
        isAuthorized = (status == .authorized)
        
        switch status {
        case .authorized:
            statusMessage = "SUCCESS! MusicKit is authorized! 🎉"
            errorMessage = nil
        case .denied:
            statusMessage = "User denied access"
            errorMessage = "User tapped 'Don't Allow'"
        case .restricted:
            statusMessage = "Access restricted"
            errorMessage = "Parental controls or device restrictions"
        case .notDetermined:
            statusMessage = "Still not determined"
            errorMessage = "Something unexpected happened"
        @unknown default:
            statusMessage = "Unknown status"
            errorMessage = "Unexpected authorization state"
        }
    }
    
    // Test fetching user's music library (requires authorization)
    func testMusicLibraryAccess() async {
        guard isAuthorized else {
            errorMessage = "Not authorized - request permission first!"
            return
        }
        
        do {
            // Try to get current storefront
            let storefront = try await MusicDataRequest.currentCountryCode
            statusMessage = "Connected to Apple Music! Storefront: \(storefront) 🌍"
            errorMessage = nil
        } catch {
            statusMessage = "Library access failed"
            errorMessage = "Error: \(error.localizedDescription)"
        }
    }
}
