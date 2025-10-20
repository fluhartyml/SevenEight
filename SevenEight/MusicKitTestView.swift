//
//  MusicKitTestView.swift
//  SevenEight
//
//  Simple test view to verify MusicKit authorization
//

import SwiftUI
import MusicKit

struct MusicKitTestView: View {
    @State private var manager = MusicKitTestManager()
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 40) {
                Text("MusicKit Test")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                // Status display
                VStack(spacing: 20) {
                    Text("Status:")
                        .font(.system(size: 24))
                        .foregroundColor(.gray)
                    
                    Text(manager.statusMessage)
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(manager.isAuthorized ? .green : .orange)
                        .multilineTextAlignment(.center)
                    
                    if let error = manager.errorMessage {
                        Text(error)
                            .font(.system(size: 20))
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                }
                
                Spacer()
                
                // Test buttons
                VStack(spacing: 20) {
                    Button(action: {
                        Task {
                            await manager.requestAuthorization()
                        }
                    }) {
                        Text("Request MusicKit Permission")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 20)
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    .buttonStyle(.plain)
                    
                    if manager.isAuthorized {
                        Button(action: {
                            Task {
                                await manager.testMusicLibraryAccess()
                            }
                        }) {
                            Text("Test Music Library Access")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 20)
                                .background(Color.green)
                                .cornerRadius(12)
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                Spacer()
            }
            .padding(40)
        }
        .onAppear {
            manager.checkCurrentStatus()
        }
    }
}

#Preview {
    MusicKitTestView()
}
