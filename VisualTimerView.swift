//
//  VisualTimerView.swift
//  Time2See
//
//  Created by EVYATAR DAYAN on 17/07/2025.
//

import SwiftUI
import AVFoundation
import Pow

struct VisualTimerView: View {
    let totalSeconds: Int
    let visualType: TimerView.VisualType
    let isIPad: Bool
    @State private var remainingSeconds: Int
    @State private var timer: Timer?
    @State private var isActive = false
    @State private var isViewReady = false
    @State private var currentMusicState: MusicState = .music1
    @State private var audioPlayer: AVAudioPlayer?
    @State private var showingTimerComplete = false
    @State private var timesUpPlayer: AVAudioPlayer?
    @State private var timesUpTimer: Timer?
    @State private var timesUpPlayCount = 0

    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settingsManager: SettingsManager
    
    init(totalSeconds: Int, visualType: TimerView.VisualType, isIPad: Bool = false) {
        self.totalSeconds = totalSeconds
        self.visualType = visualType
        self.isIPad = isIPad
        self._remainingSeconds = State(initialValue: totalSeconds)
    }
    
    private var localizedText: (String) -> String {
        return { key in
            LocalizationManager.shared.localizedString(key, language: settingsManager.selectedLanguage)
        }
    }
    
    enum MusicState: Int, CaseIterable {
        case mute = 0
        case music1 = 1
        case music2 = 2
        case music3 = 3
        case music4 = 4
        
        var icon: String {
            return "speaker.wave.3.fill"
        }
        
        var color: Color {
            switch self {
            case .mute:
                return .gray
            case .music1:
                return .blue
            case .music2:
                return .green
            case .music3:
                return .orange
            case .music4:
                return .purple
            }
        }
        
        var fileName: String? {
            switch self {
            case .mute:
                return nil
            case .music1:
                return "music1"
            case .music2:
                return "music2"
            case .music3:
                return "music3"
            case .music4:
                return "music4"
            }
        }
    }
    
    init(totalSeconds: Int, visualType: TimerView.VisualType) {
        self.totalSeconds = totalSeconds
        self.visualType = visualType
        self.isIPad = false
        self._remainingSeconds = State(initialValue: totalSeconds)
    }
    

    
    var body: some View {
        ZStack {
            // Fullscreen background image for square, triangle, circle, hexagon, star, and battery timers
            if visualType == .square {
                Image(isIPad ? "SquarePatternIpad" : "SquarePattern")
                    .resizable()
                    .ignoresSafeArea()
                    .opacity(0.1)
            } else if visualType == .triangle {
                Image(isIPad ? "TrianglePatternIpad" : "TrianglePattern")
                    .resizable()
                    .ignoresSafeArea()
                    .opacity(0.1)
            } else if visualType == .circle {
                Image(isIPad ? "CirclePatternIpad" : "CirclePattern")
                    .resizable()
                    .ignoresSafeArea()
                    .opacity(0.1)
            } else if visualType == .hexagon {
                Image(isIPad ? "HexagonPatternIpad" : "HexagonPattern")
                    .resizable()
                    .ignoresSafeArea()
                    .opacity(0.1)
            } else if visualType == .star {
                Image(isIPad ? "StarPatternIpad" : "StarPattern")
                    .resizable()
                    .ignoresSafeArea()
                    .opacity(0.1)
            } else if visualType == .battery {
                Image(isIPad ? "BatteryPatternIpad" : "BatteryPattern")
                    .resizable()
                    .ignoresSafeArea()
                    .opacity(0.1)
            }
            
            VStack(spacing: 0) {
                // Add padding for iPad
                if isIPad {
                    Color.clear
                        .frame(height: 0)
                }
            // Header with time display
            VStack(spacing: 10) {
                Text(localizedText("time_remaining"))
//                    .font(.headline)
                    .font(.system(size: isIPad ? 30 : 20, weight: .bold))
                    .foregroundColor(.secondary)
                    .padding(.bottom, isIPad ? 20 : 10)
                
                Text(timeString(from: remainingSeconds))
                    .font(.system(size: isIPad ? 60 : 36, weight: .bold, design: .monospaced))
                    .foregroundColor(.primary)
                    .padding(.horizontal, isIPad ? 40 : 20)
                    .padding(.vertical, isIPad ? 20 : 10)
                    .background(
                        RoundedRectangle(cornerRadius: isIPad ? 25 : 15)
                            .fill(Color.blue.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: isIPad ? 25 : 15)
                                    .stroke(Color.blue.opacity(0.3), lineWidth: isIPad ? 3 : 2)
                            )
                    )
            }
            .padding()
            .padding(.horizontal, isIPad ? 40 : 0)
            
            // Visual display area - takes remaining space
            GeometryReader { geometry in
                if visualType == .bricks {
                    // Bricks visual - scaled count for better performance
                    let availableWidth = geometry.size.width - (isIPad ? 180 : 40) // Account for padding
                    let availableHeight = geometry.size.height - 20 // Account for padding
                    
                    // Scale down the number of items for longer timers
                    let scaledTotalItems = calculateScaledItems(totalSeconds: totalSeconds)
                    let scaledRemainingItems = Int(Double(scaledTotalItems) * (Double(remainingSeconds) / Double(totalSeconds)))
                    
                    let (columns, brickSize) = calculateBrickLayout(
                        totalItems: scaledTotalItems,
                        availableWidth: availableWidth,
                        availableHeight: availableHeight
                    )
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.fixed(brickSize), spacing: 4), count: columns), spacing: 4) {
                        ForEach(0..<scaledTotalItems, id: \.self) { index in
                            let displayIndex = scaledTotalItems - 1 - index
                            BrickView(
                                isVisible: isViewReady && isElementVisible(index: displayIndex, totalItems: scaledTotalItems, remainingItems: scaledRemainingItems, columns: columns),
                                size: brickSize
                            )
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, 20)
                } else if visualType == .circle {
                    // Circle visual
                    CircleVisualView(
                        totalSeconds: totalSeconds,
                        remainingSeconds: remainingSeconds,
                        isViewReady: isViewReady,
                        localizedText: localizedText
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, 20)
                } else if visualType == .square {
                    // Square visual
                    SquareVisualView(
                        totalSeconds: totalSeconds,
                        remainingSeconds: remainingSeconds,
                        isViewReady: isViewReady,
                        localizedText: localizedText
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, 20)
                } else if visualType == .bubbles {
                    // Bubbles visual - scaled count for better performance
                    let availableWidth = geometry.size.width - (isIPad ? 180 : 40) // Account for padding
                    let availableHeight = geometry.size.height - 20 // Account for padding
                    
                    // Scale down the number of items for longer timers
                    let scaledTotalItems = calculateScaledItems(totalSeconds: totalSeconds)
                    let scaledRemainingItems = Int(Double(scaledTotalItems) * (Double(remainingSeconds) / Double(totalSeconds)))
                    
                    let (columns, bubbleSize) = calculateBubbleLayout(
                        totalItems: scaledTotalItems,
                        availableWidth: availableWidth,
                        availableHeight: availableHeight
                    )
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.fixed(bubbleSize), spacing: 4), count: columns), spacing: 4) {
                        ForEach(0..<scaledTotalItems, id: \.self) { index in
                            let displayIndex = scaledTotalItems - 1 - index
                            BubbleView(
                                isVisible: isViewReady && isElementVisible(index: displayIndex, totalItems: scaledTotalItems, remainingItems: scaledRemainingItems, columns: columns),
                                balloonType: balloonType(for: index),
                                size: bubbleSize
                            )
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, 20)
                } else if visualType == .candies {
                    // Candies visual - scaled count for better performance
                    let availableWidth = geometry.size.width - (isIPad ? 180 : 40) // Account for padding
                    let availableHeight = geometry.size.height - 20 // Account for padding
                    
                    // Scale down the number of items for longer timers
                    let scaledTotalItems = calculateScaledItems(totalSeconds: totalSeconds)
                    let scaledRemainingItems = Int(Double(scaledTotalItems) * (Double(remainingSeconds) / Double(totalSeconds)))
                    
                    let (columns, candySize) = calculateCandyLayout(
                        totalItems: scaledTotalItems,
                        availableWidth: availableWidth,
                        availableHeight: availableHeight
                    )
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.fixed(candySize), spacing: 4), count: columns), spacing: 4) {
                        ForEach(0..<scaledTotalItems, id: \.self) { index in
                            let displayIndex = scaledTotalItems - 1 - index
                            CandyView(
                                isVisible: isViewReady && isElementVisible(index: displayIndex, totalItems: scaledTotalItems, remainingItems: scaledRemainingItems, columns: columns),
                                candyType: candyType(for: index),
                                size: candySize
                            )
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, 20)
                } else if visualType == .balls {
                    // Balls visual - scaled count for better performance
                    let availableWidth = geometry.size.width - (isIPad ? 180 : 40) // Account for padding
                    let availableHeight = geometry.size.height - 20 // Account for padding
                    
                    // Scale down the number of items for longer timers
                    let scaledTotalItems = calculateScaledItems(totalSeconds: totalSeconds)
                    let scaledRemainingItems = Int(Double(scaledTotalItems) * (Double(remainingSeconds) / Double(totalSeconds)))
                    
                    let (columns, ballSize) = calculateBallLayout(
                        totalItems: scaledTotalItems,
                        availableWidth: availableWidth,
                        availableHeight: availableHeight
                    )
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.fixed(ballSize), spacing: 4), count: columns), spacing: 4) {
                        ForEach(0..<scaledTotalItems, id: \.self) { index in
                            let displayIndex = scaledTotalItems - 1 - index
                            BallView(
                                isVisible: isViewReady && isElementVisible(index: displayIndex, totalItems: scaledTotalItems, remainingItems: scaledRemainingItems, columns: columns),
                                ballType: ballType(for: index),
                                size: ballSize
                            )
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, 20)
                } else if visualType == .triangle {
                    // Triangle visual
                    TriangleVisualView(
                        totalSeconds: totalSeconds,
                        remainingSeconds: remainingSeconds,
                        isViewReady: isViewReady,
                        localizedText: localizedText
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, 20)
                } else if visualType == .hexagon {
                    // Hexagon visual
                    HexagonVisualView(
                        totalSeconds: totalSeconds,
                        remainingSeconds: remainingSeconds,
                        isViewReady: isViewReady,
                        localizedText: localizedText
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, 20)
                } else if visualType == .star {
                    // Star visual
                    StarVisualView(
                        totalSeconds: totalSeconds,
                        remainingSeconds: remainingSeconds,
                        isViewReady: isViewReady,
                        localizedText: localizedText
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, 20)
                } else if visualType == .battery {
                    // Battery visual
                    BatteryVisualView(
                        totalSeconds: totalSeconds,
                        remainingSeconds: remainingSeconds,
                        isViewReady: isViewReady,
                        localizedText: localizedText,
                        totalSquares: calculateScaledItems(totalSeconds: totalSeconds)
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, 20)
                } else if visualType == .hearts {
                    // Hearts visual
                    HeartsVisualView(
                        totalSeconds: totalSeconds,
                        remainingSeconds: remainingSeconds,
                        isViewReady: isViewReady
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, 20)
                } else if visualType == .emoji {
                    // Emoji visual
                    EmojiVisualView(
                        totalSeconds: totalSeconds,
                        remainingSeconds: remainingSeconds,
                        isViewReady: isViewReady
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal)
                } else if visualType == .toys {
                    // Toys visual - scaled count for better performance
                    let availableWidth = geometry.size.width - (isIPad ? 180 : 40) // Account for padding
                    let availableHeight = geometry.size.height - 20 // Account for padding
                    
                    // Scale down the number of items for longer timers
                    let scaledTotalItems = calculateScaledItems(totalSeconds: totalSeconds)
                    let scaledRemainingItems = Int(Double(scaledTotalItems) * (Double(remainingSeconds) / Double(totalSeconds)))
                    
                    let (columns, toySize) = calculateToyLayout(
                        totalItems: scaledTotalItems,
                        availableWidth: availableWidth,
                        availableHeight: availableHeight
                    )
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.fixed(toySize), spacing: 4), count: columns), spacing: 4) {
                        ForEach(0..<scaledTotalItems, id: \.self) { index in
                            let displayIndex = scaledTotalItems - 1 - index
                            ToyView(
                                isVisible: isViewReady && isElementVisible(index: displayIndex, totalItems: scaledTotalItems, remainingItems: scaledRemainingItems, columns: columns),
                                toyType: toyType(for: index),
                                size: toySize
                            )
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, 20)
                }
            }
            .padding(.bottom, 20)
            
            // Control buttons - always at bottom
            HStack(spacing: 20) {
                Button(action: {
                    if isActive {
                        pauseTimer()
                    } else {
                        startTimer()
                    }
                }) {
                    Text(isActive ? localizedText("pause") : localizedText("start"))
                        .font(.system(size: isIPad ? 22 : 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: isIPad ? 200 : .infinity)
                        .padding(isIPad ? 15 : 12)
                        .background(
                            RoundedRectangle(cornerRadius: isIPad ? 20 : 15)
                                .fill(isActive ? Color.orange : Color.green)
                        )
                }
                
                Button(action: {
                    resetTimer()
                }) {
                    Text(localizedText("reset"))
                        .font(.system(size: isIPad ? 22 : 16, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .frame(maxWidth: isIPad ? 200 : .infinity)
                        .padding(isIPad ? 15 : 12)
                        .background(
                            RoundedRectangle(cornerRadius: isIPad ? 20 : 15)
                                .fill(Color.red)
                        )
                }
            }
            .padding(.horizontal, isIPad ? 40 : 20)
            .padding(.bottom)
        }
        }
        .overlay(
            // Sound button in top left and X button in top right
            VStack {
                HStack {
                    // Sound button on the left
                    Button(action: {
                        cycleMusicState()
                    }) {
                        ZStack {
                            Image(systemName: currentMusicState.icon)
                                .font(.system(size: isIPad ? 30 : 20))
                                .foregroundColor(currentMusicState == .mute ? .gray : .green)
                                .padding(isIPad ? 15 : 8)
                                .background(
                                    Circle()
                                        .fill((currentMusicState == .mute ? Color.gray : Color.green).opacity(0.1))
                                        .overlay(
                                            Circle()
                                                .stroke((currentMusicState == .mute ? Color.gray : Color.green).opacity(0.9), lineWidth: isIPad ? 3 : 2)
                                        )
                                )
                            
                            // Music state number indicator
                            Text("\(currentMusicState.rawValue)")
                                .font(.system(size: isIPad ? 24 : 14, weight: .bold))
                                .foregroundColor(.white)
                                .padding(isIPad ? 6 : 4)
                                .background(
                                    Circle()
                                        .fill(currentMusicState == .mute ? Color.gray : Color.green)
                                )
                                .offset(x: isIPad ? 18 : 12, y: isIPad ? 25 : 14)
                        }
                    }
                    
                    Spacer()
                    
                    // X button on the right
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: isIPad ? 35 : 25))
                            .foregroundColor(.red)
                            .padding(isIPad ? 12 : 7)
                            .background(
                                Circle()
                                    .fill(Color.white.opacity(0.9))
                                    .shadow(radius: isIPad ? 4 : 2)
                            )
                    }
                }
                .padding(.horizontal, isIPad ? 34 : 15)
                .padding(.top, isIPad ? 60 : 15)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        )
        .navigationTitle("Visual Timer")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(isIPad)
        .toolbar {
            if !isIPad {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        stopTimer()
                        dismiss()
                    }
                }
            }
        }
        .id(settingsManager.selectedLanguage) // Force view update when language changes
        .onAppear {
            // Mark view as ready after a short delay to prevent initial flicker
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isViewReady = true
            }
        }
        .onDisappear {
            stopTimer()
            stopMusic()
            stopTimesUpSound()
        }
        .alert(localizedText("time_is_up"), isPresented: $showingTimerComplete) {
            Button(localizedText("ok")) {
                stopTimesUpSound()
                resetTimer()
            }
        } message: {
//            Text(localizedText("timer_finished"))
        }
    }
    
    private func startTimer() {
        guard !isActive else { return }
        isActive = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if remainingSeconds > 0 {
                remainingSeconds -= 1
            } else {
                stopTimer()
                showingTimerComplete = true
                startTimesUpSound()
            }
        }
        
        // Resume music if not muted
        if currentMusicState != .mute {
            playMusic()
        }
    }
    
    private func pauseTimer() {
        isActive = false
        timer?.invalidate()
        timer = nil
        
        // Pause music when timer is paused
        audioPlayer?.pause()
    }
    
    private func resetTimer() {
        stopTimer()
        remainingSeconds = totalSeconds
    }
    
    private func stopTimer() {
        isActive = false
        timer?.invalidate()
        timer = nil
        
        // Stop music when timer is stopped
        audioPlayer?.pause()
    }
    
    private func cycleMusicState() {
        let allStates = MusicState.allCases
        if let currentIndex = allStates.firstIndex(of: currentMusicState) {
            let nextIndex = (currentIndex + 1) % allStates.count
            currentMusicState = allStates[nextIndex]
            
            // Only play music if timer is active and not muted
            if isActive && currentMusicState != .mute {
                playMusic()
            } else if currentMusicState == .mute {
                audioPlayer?.pause()
            }
        }
    }
    
    private func playMusic() {
        stopMusic()
        
        guard let fileName = currentMusicState.fileName else {
            return // Mute state
        }
        
        // Try different paths to find the music file
        var url: URL?
        
        // First try: with subdirectory
        url = Bundle.main.url(forResource: fileName, withExtension: "mp3", subdirectory: "Music")
        
        // Second try: without subdirectory (if files are directly in bundle)
        if url == nil {
            url = Bundle.main.url(forResource: fileName, withExtension: "mp3")
        }
        
        // Third try: with capitalized extension
        if url == nil {
            url = Bundle.main.url(forResource: fileName, withExtension: "MP3")
        }
        
        guard let finalUrl = url else {
            print("Could not find music file: \(fileName) in any location")
            return
        }
        
        do {
            // Configure audio session
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: finalUrl)
            audioPlayer?.numberOfLoops = -1 // Infinite loop
            
            // Set higher volume for music2.mp3
            if fileName == "music2" {
                audioPlayer?.volume = 1.2 // Full volume for music2
            } else {
                audioPlayer?.volume = 0.7 // 70% volume for other tracks
            }
            
            if audioPlayer?.play() == true {
                print("Successfully started playing: \(fileName)")
            } else {
                print("Failed to start playing: \(fileName)")
            }
        } catch {
            print("Could not play music: \(error)")
        }
    }
    
    private func stopMusic() {
        audioPlayer?.stop()
        audioPlayer = nil
        
        // Deactivate audio session when stopping
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch {
            print("Could not deactivate audio session: \(error)")
        }
    }
    
    private func startTimesUpSound() {
        // Stop any existing background music
        stopMusic()
        

        
        // Try different paths to find the TimesUp1 sound file
        var url: URL?
        
        // First try: with subdirectory
        url = Bundle.main.url(forResource: "TimesUp1", withExtension: "mp3", subdirectory: "Music")
        
        // Second try: without subdirectory
        if url == nil {
            url = Bundle.main.url(forResource: "TimesUp1", withExtension: "mp3")
        }
        
        // Third try: with capitalized extension
        if url == nil {
            url = Bundle.main.url(forResource: "TimesUp1", withExtension: "MP3")
        }
        
        guard let finalUrl = url else {
            print("Could not find TimesUp1 sound file")
            return
        }
        
        do {
            // Configure audio session
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            timesUpPlayer = try AVAudioPlayer(contentsOf: finalUrl)
            timesUpPlayer?.volume = 0.8
            timesUpPlayCount = 0
            
            // Start the repeating timer
            timesUpTimer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { _ in
                if timesUpPlayCount < 30 && showingTimerComplete {
                    timesUpPlayer?.play()
                    timesUpPlayCount += 1
                    print("Playing TimesUp1 sound - count: \(timesUpPlayCount)")
                } else {
                    stopTimesUpSound()
                }
            }
            
            // Play the first sound immediately
            timesUpPlayer?.play()
            timesUpPlayCount += 1
            print("Playing TimesUp1 sound - count: \(timesUpPlayCount)")
            
        } catch {
            print("Could not play TimesUp1 sound: \(error)")
        }
    }
    
    private func stopTimesUpSound() {
        timesUpTimer?.invalidate()
        timesUpTimer = nil
        timesUpPlayer?.stop()
        timesUpPlayer = nil
        timesUpPlayCount = 0
        print("Stopped TimesUp1 sound")
    }
    

    
    private func calculateScaledItems(totalSeconds: Int) -> Int {
        // Scale down the number of items for longer timers to maintain performance
        if totalSeconds <= 60 {
            // For 1 minute or less, use exact count
            return totalSeconds
        } else if totalSeconds <= 300 {
            // For 1-5 minutes, use 1 item per 2 seconds
            return totalSeconds / 2
        } else if totalSeconds <= 600 {
            // For 5-10 minutes, use 1 item per 3 seconds
            return totalSeconds / 3
        } else if totalSeconds <= 1200 {
            // For 10-20 minutes, use 1 item per 5 seconds
            return totalSeconds / 5
        } else {
            // For 20+ minutes, use 1 item per 10 seconds (max 300 items)
            return min(totalSeconds / 10, 300)
        }
    }
    
    private func isElementVisible(index: Int, totalItems: Int, remainingItems: Int, columns: Int) -> Bool {
        // Calculate row and column for this index
        let row = index / columns
        let col = index % columns
        
        // Calculate total rows
        let totalRows = Int(ceil(Double(totalItems) / Double(columns)))
        
        // Calculate how many complete rows should be visible
        let completeVisibleRows = remainingItems / columns
        
        // Calculate how many items should be visible in the partial row
        let itemsInPartialRow = remainingItems % columns
        
        // Element is visible if:
        // 1. It's in a complete visible row, OR
        // 2. It's in the partial row and within the visible items
        if row < completeVisibleRows {
            return true
        } else if row == completeVisibleRows && col < itemsInPartialRow {
            return true
        } else {
            return false
        }
    }
    
    private func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
    
    private func brickColor(for index: Int) -> Color {
        let progress = Double(index) / Double(totalSeconds)
        if progress < 0.33 {
            return .green
        } else if progress < 0.66 {
            return .orange
        } else {
            return .red
        }
    }
    
    private func bubbleColor(for index: Int) -> Color {
        let progress = Double(index) / Double(totalSeconds)
        if progress < 0.33 {
            return .blue
        } else if progress < 0.66 {
            return .purple
        } else {
            return .pink
        }
    }
    
    private func calculateBrickLayout(totalItems: Int, availableWidth: CGFloat, availableHeight: CGFloat) -> (columns: Int, brickSize: CGFloat) {
        // Calculate optimal brick layout - ensure exact count
        let spacing: CGFloat = 4
        let minBrickSize: CGFloat = 12 // Minimum brick size
        let maxBrickSize: CGFloat = 40 // Maximum brick size
        
        // Try different column counts to find the best fit
        var bestColumns = 1
        var bestBrickSize: CGFloat = minBrickSize
        
        for columns in 1...20 { // Reasonable range for columns
            let brickWidth = (availableWidth - (spacing * CGFloat(columns - 1))) / CGFloat(columns)
            let rows = Int(ceil(Double(totalItems) / Double(columns)))
            let brickHeight = (availableHeight - (spacing * CGFloat(rows - 1))) / CGFloat(rows)
            let brickSize = min(brickWidth, brickHeight)
            
            // Prefer larger bricks that still fit
            if brickSize >= minBrickSize && brickSize <= maxBrickSize && brickSize > bestBrickSize {
                bestBrickSize = brickSize
                bestColumns = columns
            }
        }
        
        // If no good fit found, use minimum size
        if bestBrickSize < minBrickSize {
            bestBrickSize = minBrickSize
            bestColumns = min(Int(availableWidth / (minBrickSize + spacing)), 20)
        }
        
        return (bestColumns, bestBrickSize)
    }
    
    private func calculateBubbleLayout(totalItems: Int, availableWidth: CGFloat, availableHeight: CGFloat) -> (columns: Int, bubbleSize: CGFloat) {
        // Calculate optimal bubble layout - ensure exact count
        let spacing: CGFloat = 4
        let minBubbleSize: CGFloat = 12 // Minimum bubble size
        let maxBubbleSize: CGFloat = 40 // Maximum bubble size
        
        // Try different column counts to find the best fit
        var bestColumns = 1
        var bestBubbleSize: CGFloat = minBubbleSize
        
        for columns in 1...20 { // Reasonable range for columns
            let bubbleWidth = (availableWidth - (spacing * CGFloat(columns - 1))) / CGFloat(columns)
            let rows = Int(ceil(Double(totalItems) / Double(columns)))
            let bubbleHeight = (availableHeight - (spacing * CGFloat(rows - 1))) / CGFloat(rows)
            let bubbleSize = min(bubbleWidth, bubbleHeight)
            
            // Prefer larger bubbles that still fit
            if bubbleSize >= minBubbleSize && bubbleSize <= maxBubbleSize && bubbleSize > bestBubbleSize {
                bestBubbleSize = bubbleSize
                bestColumns = columns
            }
        }
        
        // If no good fit found, use minimum size
        if bestBubbleSize < minBubbleSize {
            bestBubbleSize = minBubbleSize
            bestColumns = min(Int(availableWidth / (minBubbleSize + spacing)), 20)
        }
        
        return (bestColumns, bestBubbleSize)
    }
    
    private func isBubbleVisible(index: Int, remainingSeconds: Int, columns: Int) -> Bool {
        // Simple logic: show bubble if index is less than remaining seconds
        return index < remainingSeconds
    }
    
    private func calculateCandyLayout(totalItems: Int, availableWidth: CGFloat, availableHeight: CGFloat) -> (columns: Int, candySize: CGFloat) {
        // Calculate optimal candy layout - ensure exact count
        let spacing: CGFloat = 4
        let minCandySize: CGFloat = 12 // Minimum candy size
        let maxCandySize: CGFloat = 40 // Maximum candy size
        
        // Try different column counts to find the best fit
        var bestColumns = 1
        var bestCandySize: CGFloat = minCandySize
        
        for columns in 1...20 { // Reasonable range for columns
            let candyWidth = (availableWidth - (spacing * CGFloat(columns - 1))) / CGFloat(columns)
            let rows = Int(ceil(Double(totalItems) / Double(columns)))
            let candyHeight = (availableHeight - (spacing * CGFloat(rows - 1))) / CGFloat(rows)
            let candySize = min(candyWidth, candyHeight)
            
            // Prefer larger candies that still fit
            if candySize >= minCandySize && candySize <= maxCandySize && candySize > bestCandySize {
                bestCandySize = candySize
                bestColumns = columns
            }
        }
        
        // If no good fit found, use minimum size
        if bestCandySize < minCandySize {
            bestCandySize = minCandySize
            bestColumns = min(Int(availableWidth / (minCandySize + spacing)), 20)
        }
        
        return (bestColumns, bestCandySize)
    }
    
    private func isCandyVisible(index: Int, remainingSeconds: Int, columns: Int) -> Bool {
        // Simple logic: show candy if index is less than remaining seconds
        return index < remainingSeconds
    }
    
    private func candyType(for index: Int) -> String {
        // Simple predictable pattern
        let candyTypes = ["candy1", "candy2", "candy3", "candy4", "candy5", "candy6", "candy7", "candy8", "candy9", "candy10", "candy11", "candy12", "candy13", "candy14", "candy15", "candy16", "candy17", "candy18", "candy19", "candy20", "candy21", "candy22", "candy23", "candy24", "candy25", "candy26", "candy27", "candy28", "candy29"]
        return candyTypes[index % candyTypes.count]
    }
    
    private func balloonType(for index: Int) -> String {
        // Simple predictable pattern
        let balloonTypes = ["balloon1", "balloon2", "balloon3", "balloon4", "balloon5", "balloon6", "balloon7", "balloon8", "balloon9", "balloon10", "balloon11", "balloon12", "balloon13", "balloon14", "balloon15", "balloon16", "balloon17", "balloon18", "balloon19", "balloon20", "balloon21", "balloon22", "balloon23", "balloon24", "balloon25", "balloon26", "balloon27", "balloon28", "balloon29", "balloon30", "balloon31",]
        return balloonTypes[index % balloonTypes.count]
    }
    
    private func calculateBallLayout(totalItems: Int, availableWidth: CGFloat, availableHeight: CGFloat) -> (columns: Int, ballSize: CGFloat) {
        // Calculate optimal ball layout - ensure exact count
        let spacing: CGFloat = 4
        let minBallSize: CGFloat = 12 // Minimum ball size
        let maxBallSize: CGFloat = 40 // Maximum ball size
        
        // Try different column counts to find the best fit
        var bestColumns = 1
        var bestBallSize: CGFloat = minBallSize
        
        for columns in 1...20 { // Reasonable range for columns
            let ballWidth = (availableWidth - (spacing * CGFloat(columns - 1))) / CGFloat(columns)
            let rows = Int(ceil(Double(totalItems) / Double(columns)))
            let ballHeight = (availableHeight - (spacing * CGFloat(rows - 1))) / CGFloat(rows)
            let ballSize = min(ballWidth, ballHeight)
            
            // Prefer larger balls that still fit
            if ballSize >= minBallSize && ballSize <= maxBallSize && ballSize > bestBallSize {
                bestBallSize = ballSize
                bestColumns = columns
            }
        }
        
        // If no good fit found, use minimum size
        if bestBallSize < minBallSize {
            bestBallSize = minBallSize
            bestColumns = min(Int(availableWidth / (minBallSize + spacing)), 20)
        }
        
        return (bestColumns, bestBallSize)
    }
    
    private func isBallVisible(index: Int, remainingSeconds: Int, columns: Int) -> Bool {
        // Simple logic: show ball if index is less than remaining seconds
        return index < remainingSeconds
    }
    
    private func ballType(for index: Int) -> String {
        // Simple predictable pattern
        let ballTypes = ["ball1", "ball2", "ball3", "ball4", "ball5", "ball6", "ball7", "ball8", "ball9", "ball10", "ball11", "ball12", "ball13", "ball14", "ball15", "ball16", "ball17", "ball18", "ball19", "ball20", "ball21", "ball22", "ball23", "ball24", "ball25", "ball26"]
        return ballTypes[index % ballTypes.count]
    }
    
    private func calculateToyLayout(totalItems: Int, availableWidth: CGFloat, availableHeight: CGFloat) -> (columns: Int, toySize: CGFloat) {
        // Calculate optimal toy layout - ensure exact count
        let spacing: CGFloat = 4
        let minToySize: CGFloat = 12 // Minimum toy size
        let maxToySize: CGFloat = 40 // Maximum toy size
        
        // Try different column counts to find the best fit
        var bestColumns = 1
        var bestToySize: CGFloat = minToySize
        
        for columns in 1...20 { // Reasonable range for columns
            let toyWidth = (availableWidth - (spacing * CGFloat(columns - 1))) / CGFloat(columns)
            let rows = Int(ceil(Double(totalItems) / Double(columns)))
            let toyHeight = (availableHeight - (spacing * CGFloat(rows - 1))) / CGFloat(rows)
            let toySize = min(toyWidth, toyHeight)
            
            // Prefer larger toys that still fit
            if toySize >= minToySize && toySize <= maxToySize && toySize > bestToySize {
                bestToySize = toySize
                bestColumns = columns
            }
        }
        
        // If no good fit found, use minimum size
        if bestToySize < minToySize {
            bestToySize = minToySize
            bestColumns = min(Int(availableWidth / (minToySize + spacing)), 20)
        }
        
        return (bestColumns, bestToySize)
    }
    
    private func toyType(for index: Int) -> String {
        // Simple predictable pattern
        let toyTypes = ["toy1", "toy2", "toy3", "toy4", "toy5", "toy6", "toy7", "toy8", "toy9", "toy10", "toy11", "toy12", "toy13", "toy14", "toy15", "toy16", "toy17", "toy18", "toy19", "toy20", "toy21", "toy22", "toy23", "toy24", "toy25", "toy26", "toy27", "toy28", "toy29", "toy30", "toy31", "toy32", "toy33", "toy34", "toy35", "toy36", "toy37", "toy38"]
        return toyTypes[index % toyTypes.count]
    }
    
    private func isBrickVisible(index: Int, remainingSeconds: Int, columns: Int) -> Bool {
        // Simple logic: show brick if index is less than remaining seconds
        return index < remainingSeconds
    }
}

struct BrickView: View {
    let isVisible: Bool
    let size: CGFloat
    
    var body: some View {
        ZStack {
            // Invisible placeholder to maintain layout
            Color.clear
                .frame(width: size, height: size)
            
            // Visible brick with POW animation
            if isVisible {
                Image("brick")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
                    .transition(.movingParts.poof)
            }
        }
    }
}

struct BubbleView: View {
    let isVisible: Bool
    let balloonType: String
    let size: CGFloat
    
    var body: some View {
        Image(balloonType)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
            .opacity(isVisible ? 1.0 : 0.0)
            .offset(y: isVisible ? 0 : -50)
            .animation(.easeInOut(duration: 0.8), value: isVisible)
    }
}

struct CandyView: View {
    let isVisible: Bool
    let candyType: String
    let size: CGFloat
    
    var body: some View {
        Image(candyType)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
            .opacity(isVisible ? 1.0 : 0.0)
            .scaleEffect(isVisible ? 1.0 : 0.0)
            .offset(y: isVisible ? 0 : -20)
            .animation(.spring(response: 0.4, dampingFraction: 0.5), value: isVisible)
    }
}

struct BallView: View {
    let isVisible: Bool
    let ballType: String
    let size: CGFloat
    
    var body: some View {
        Image(ballType)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
            .opacity(isVisible ? 1.0 : 0.0)
            .rotationEffect(.degrees(isVisible ? 0 : -180))
            .offset(x: isVisible ? 0 : -60)
            .animation(.easeInOut(duration: 0.8), value: isVisible)
    }
}

struct ToyView: View {
    let isVisible: Bool
    let toyType: String
    let size: CGFloat
    
    var body: some View {
        Image(toyType)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
            .opacity(isVisible ? 1.0 : 0.0)
            .offset(x: isVisible ? 0 : -50)
            .animation(.easeInOut(duration: 0.5), value: isVisible)
    }
}

struct HeartView: View {
    let isVisible: Bool
    let heartType: String
    let size: CGFloat
    
    var body: some View {
        Image(heartType)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
            .opacity(isVisible ? 1.0 : 0.0)
            .scaleEffect(isVisible ? 1.0 : 2.0)
            .animation(.easeInOut(duration: 0.6), value: isVisible)
    }
}

struct EmojiView: View {
    let isVisible: Bool
    let emojiType: String
    let size: CGFloat
    
    var body: some View {
        Image(emojiType)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
            .opacity(isVisible ? 1.0 : 0.0)
            .offset(x: isVisible ? 0 : -50)
            .animation(.easeInOut(duration: 0.5), value: isVisible)
    }
}

struct CircleVisualView: View {
    let totalSeconds: Int
    let remainingSeconds: Int
    let isViewReady: Bool
    let localizedText: (String) -> String
    
    var body: some View {
        GeometryReader { geometry in
            let isIPad = UIDevice.current.userInterfaceIdiom == .pad
            let size = min(geometry.size.width, geometry.size.height) - (isIPad ? 250 : 80) // Smaller on iPad
            let strokeWidth: CGFloat = isIPad ? 50 : 35
            
            ZStack {
                // Background circle
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: strokeWidth)
                    .frame(width: size, height: size)
                
                // Progress circle
                Circle()
                    .trim(from: 0, to: isViewReady ? CGFloat(remainingSeconds) / CGFloat(totalSeconds) : 1.0)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [.green, .orange, .red]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round)
                    )
                    .frame(width: size, height: size)
                    .rotationEffect(.degrees(-90)) // Start from top
                    .animation(.easeInOut(duration: 0.3), value: remainingSeconds)
                
                // Center text
                VStack(spacing: 5) {
                    Text("\(remainingSeconds)")
                        .font(.system(size: size * 0.12, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text(localizedText("seconds"))
                        .font(.system(size: size * 0.04, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct SquareVisualView: View {
    let totalSeconds: Int
    let remainingSeconds: Int
    let isViewReady: Bool
    let localizedText: (String) -> String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        GeometryReader { geometry in
            let isIPad = UIDevice.current.userInterfaceIdiom == .pad
            let size = min(geometry.size.width, geometry.size.height) - (isIPad ? 250 : 80) // Smaller on iPad
            let strokeWidth: CGFloat = isIPad ? 50 : 35
            
            ZStack {
                // Background square
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray.opacity(0.3), lineWidth: strokeWidth)
                    .frame(width: size, height: size)
                
                // Progress square
                RoundedRectangle(cornerRadius: 20)
                    .trim(from: 0, to: isViewReady ? CGFloat(remainingSeconds) / CGFloat(totalSeconds) : 1.0)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [.green, .orange, .red]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round)
                    )
                    .frame(width: size, height: size)
                    .rotationEffect(.degrees(-90)) // Start from top
                    .animation(.easeInOut(duration: 0.3), value: remainingSeconds)
                
                // Center text
                VStack(spacing: 5) {
                    Text("\(remainingSeconds)")
                        .font(.system(size: size * 0.12, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text(localizedText("seconds"))
                        .font(.system(size: size * 0.04, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct TriangleVisualView: View {
    let totalSeconds: Int
    let remainingSeconds: Int
    let isViewReady: Bool
    let localizedText: (String) -> String
    
    var body: some View {
        GeometryReader { geometry in
            let isIPad = UIDevice.current.userInterfaceIdiom == .pad
            let size = min(geometry.size.width, geometry.size.height) - (isIPad ? 250 : 80) // Smaller on iPad
            let strokeWidth: CGFloat = isIPad ? 50 : 35
            
            ZStack {
                // Background triangle
                Triangle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: strokeWidth)
                    .frame(width: size, height: size)
                
                // Progress triangle
                Triangle()
                    .trim(from: 0, to: isViewReady ? CGFloat(remainingSeconds) / CGFloat(totalSeconds) : 1.0)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [.green, .orange, .red]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round)
                    )
                    .frame(width: size, height: size)
                    .rotationEffect(.degrees(0)) // No rotation needed for upward triangle
                    .animation(.easeInOut(duration: 0.3), value: remainingSeconds)
                
                // Center text
                VStack(spacing: 5) {
                    Text("\(remainingSeconds)")
                        .font(.system(size: size * 0.12, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text(localizedText("seconds"))
                        .font(.system(size: size * 0.04, weight: .medium))
                        .foregroundColor(.secondary)
                }
                .offset(y: size * 0.1) // Move text down slightly
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct HexagonVisualView: View {
    let totalSeconds: Int
    let remainingSeconds: Int
    let isViewReady: Bool
    let localizedText: (String) -> String
    
    var body: some View {
        GeometryReader { geometry in
            let isIPad = UIDevice.current.userInterfaceIdiom == .pad
            let size = min(geometry.size.width, geometry.size.height) - (isIPad ? 220 : 80) // Smaller on iPad
            let strokeWidth: CGFloat = isIPad ? 50 : 35
            
            ZStack {
                // Background hexagon
                Hexagon()
                    .stroke(Color.gray.opacity(0.3), lineWidth: strokeWidth)
                    .frame(width: size, height: size)
                
                // Progress hexagon
                Hexagon()
                    .trim(from: 0, to: isViewReady ? CGFloat(remainingSeconds) / CGFloat(totalSeconds) : 1.0)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [.green, .orange, .red]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round)
                    )
                    .frame(width: size, height: size)
                    .animation(.easeInOut(duration: 0.3), value: remainingSeconds)
                
                // Center text
                VStack(spacing: 5) {
                    Text("\(remainingSeconds)")
                        .font(.system(size: size * 0.12, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text(localizedText("seconds"))
                        .font(.system(size: size * 0.04, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct StarVisualView: View {
    let totalSeconds: Int
    let remainingSeconds: Int
    let isViewReady: Bool
    let localizedText: (String) -> String
    
    var body: some View {
        GeometryReader { geometry in
            let isIPad = UIDevice.current.userInterfaceIdiom == .pad
            let size = min(geometry.size.width, geometry.size.height) - (isIPad ? 200 : 80) // Same size as other shapes
            let strokeWidth: CGFloat = isIPad ? 40 : 27 // Thinner stroke for star
            
            ZStack {
                // Background star
                Star()
                    .stroke(Color.gray.opacity(0.3), lineWidth: strokeWidth)
                    .frame(width: size, height: size)
                
                // Progress star
                Star()
                    .trim(from: 0, to: isViewReady ? CGFloat(remainingSeconds) / CGFloat(totalSeconds) : 1.0)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [.green, .orange, .red]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round)
                    )
                    .frame(width: size, height: size)
                    .animation(.easeInOut(duration: 0.3), value: remainingSeconds)
                
                // Center text
                VStack(spacing: 5) {
                    Text("\(remainingSeconds)")
                        .font(.system(size: size * 0.12, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text(localizedText("seconds"))
                        .font(.system(size: size * 0.04, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct BatteryVisualView: View {
    let totalSeconds: Int
    let remainingSeconds: Int
    let isViewReady: Bool
    let localizedText: (String) -> String
    let totalSquares: Int
    
    var body: some View {
        GeometryReader { geometry in
            let isIPad = UIDevice.current.userInterfaceIdiom == .pad
            let size = min(geometry.size.width, geometry.size.height) - (isIPad ? 300 : 80) // Smaller on iPad
            let strokeWidth: CGFloat = isIPad ? 50 : 35 // Thicker stroke for battery
            
            ZStack {
                // Background battery
                Battery()
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [.green.opacity(0.7), .orange.opacity(0.7), .red.opacity(0.7)]),
                            startPoint: .topLeading,
                            endPoint: .bottomLeading
                        ),
                        lineWidth: strokeWidth
                    )
                    .frame(width: size, height: size)
                
                // Progress battery (filled with squares)
                BatteryProgressView(
                    totalSeconds: totalSeconds,
                    remainingSeconds: remainingSeconds,
                    isViewReady: isViewReady,
                    size: size,
                    totalSquares: totalSquares
                )
                .frame(width: size, height: size)
                
                // Energetic image overlay
                Image("energetic")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size * 0.5, height: size * 0.5) // 40% of battery size
                    .opacity(0.7) // 70% opacity
                    .position(x: isIPad ? size / 1.22 : size / 1.55, y: isIPad ? size * 0.85 : size * 0.95) // Same position as seconds text
                
                // Bottom text
                VStack(spacing: 5) {
                    Text("\(remainingSeconds)")
                        .font(.system(size: size * 0.12, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text(localizedText("seconds"))
                        .font(.system(size: size * 0.04, weight: .medium))
                        .foregroundColor(.secondary)
                }
//                .position(x: size / 1.25, y: size * 1.3) // Position at lower part of battery
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct BatteryProgressView: View {
    let totalSeconds: Int
    let remainingSeconds: Int
    let isViewReady: Bool
    let size: CGFloat
    let totalSquares: Int
    
    var body: some View {
        GeometryReader { geometry in
            let totalWidth = size
            let totalHeight = size
            
            // Use the same proportions as the Battery shape
            let bodyWidth = totalHeight * 0.80  // Same as battery shape
            let bodyHeight = totalWidth * 1.8   // Same as battery shape - taller for realistic look
            let cornerRadius = min(totalWidth, totalHeight) * 0.1
            
            // Calculate battery body position (same as battery shape)
            let bodyX = (totalWidth - bodyWidth) / 2
            let bodyY = (totalHeight - bodyHeight) / 2
            
            // Calculate how many squares to show based on remaining time
            let progress = isViewReady ? CGFloat(remainingSeconds) / CGFloat(totalSeconds) : 1.0
            let visibleSquares = Int(CGFloat(totalSquares) * progress)
            
            // For disappearing from top, we need to show squares from bottom up
            let squaresToShow = totalSquares - visibleSquares
            
            // Grid layout for squares - optimized for battery proportions
            let columns = Int(sqrt(Double(totalSquares))) + 1
            let rows = Int(ceil(Double(totalSquares) / Double(columns)))
            
            // Calculate square size - make squares smaller to fit all within battery
            let widthBasedSize = bodyWidth / CGFloat(columns)
            let heightBasedSize = bodyHeight / CGFloat(rows)
            let minSquareSize: CGFloat = 6 // Smaller minimum square size
            let calculatedSize = min(widthBasedSize, heightBasedSize) * 0.8 // Use smaller of width/height and reduce multiplier
            let squareSize = max(calculatedSize, minSquareSize) // Ensure squares don't get too small
            
            // Calculate actual grid dimensions
            let gridWidth = CGFloat(columns) * squareSize + CGFloat(columns - 1) * 1 // Include spacing
            let gridHeight = CGFloat(rows) * squareSize + CGFloat(rows - 1) * 1 // Include spacing
            
            ZStack {
                // Battery outline (same as battery shape)
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.clear, lineWidth: 0)
                    .frame(width: bodyWidth, height: bodyHeight)
                    .position(x: bodyX + bodyWidth / 2, y: bodyY + bodyHeight / 2)
                
                // Squares grid - properly constrained to battery interior
                LazyVGrid(columns: Array(repeating: GridItem(.fixed(squareSize), spacing: 1), count: columns), spacing: 1) {
                    ForEach(0..<totalSquares, id: \.self) { index in
                        BatterySquareView(
                            isVisible: index >= squaresToShow,
                            row: index / columns,
                            totalRows: rows,
                            isVertical: true
                        )
                        .frame(width: squareSize, height: squareSize)
                    }
                }
                .frame(width: gridWidth, height: gridHeight) // Use calculated grid dimensions to show all squares
                .clipped() // Ensure squares don't extend outside the frame
                .position(x: bodyX + bodyWidth / 2, y: bodyY + bodyHeight / 2) // Center the grid within battery body
            }
            .frame(width: totalWidth, height: totalHeight)
            .clipped()
        }
    }
}

struct BatterySquareView: View {
    let isVisible: Bool
    let row: Int
    let totalRows: Int
    let isVertical: Bool
    
    private var squareColor: Color {
        // For testing - all squares green to see if height utilization works
        return .green
    }
    
    var body: some View {
        ZStack {
            // Invisible placeholder to maintain layout
            Color.clear
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Visible square with POW animation
            if isVisible {
                RoundedRectangle(cornerRadius: 2)
                    .fill(squareColor)
                    .transition(.movingParts.poof)
            }
        }
    }
}

struct HeartsVisualView: View {
    let totalSeconds: Int
    let remainingSeconds: Int
    let isViewReady: Bool
    
    // Generate random layout once when view is created
    private let randomHeartTypes: [String]
    
    init(totalSeconds: Int, remainingSeconds: Int, isViewReady: Bool) {
        self.totalSeconds = totalSeconds
        self.remainingSeconds = remainingSeconds
        self.isViewReady = isViewReady
        
        // Generate simple predictable heart layout
        let scaledTotalItems = Self.calculateScaledItems(totalSeconds: totalSeconds)
        let heartTypes = ["heart0", "heart1", "heart2", "heart3", "heart4", "heart5", "heart6", "heart7", "heart8", "heart9", "heart10", "heart11", "heart12", "heart13", "heart14", "heart15", "heart16", "heart17", "heart18", "heart19", "heart20", "heart21", "heart22", "heart23", "heart24", "heart25", "heart26", "heart27", "heart28", "heart29"]
        self.randomHeartTypes = (0..<scaledTotalItems).map { index in
            heartTypes[index % heartTypes.count]
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            let isIPad = UIDevice.current.userInterfaceIdiom == .pad
            let availableWidth = geometry.size.width - (isIPad ? 180 : 40)
            let availableHeight = geometry.size.height - 20
            
            // Use pre-generated random layout
            let scaledTotalItems = randomHeartTypes.count
            let scaledRemainingItems = Int(Double(scaledTotalItems) * (Double(remainingSeconds) / Double(totalSeconds)))
            
            let (columns, heartSize) = calculateHeartLayout(
                totalItems: scaledTotalItems,
                availableWidth: availableWidth,
                availableHeight: availableHeight
            )
            
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(heartSize), spacing: 4), count: columns), spacing: 4) {
                ForEach(0..<scaledTotalItems, id: \.self) { index in
                    let displayIndex = scaledTotalItems - 1 - index
                    HeartView(
                        isVisible: isViewReady && isElementVisible(index: displayIndex, totalItems: scaledTotalItems, remainingItems: scaledRemainingItems, columns: columns),
                        heartType: heartType(for: index),
                        size: heartSize
                    )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal)
        }
    }
    
    private func calculateHeartLayout(totalItems: Int, availableWidth: CGFloat, availableHeight: CGFloat) -> (columns: Int, heartSize: CGFloat) {
        // Calculate optimal heart layout - ensure exact count
        let spacing: CGFloat = 4
        let minHeartSize: CGFloat = 12 // Minimum heart size
        let maxHeartSize: CGFloat = 40 // Maximum heart size
        
        // Try different column counts to find the best fit
        var bestColumns = 1
        var bestHeartSize: CGFloat = minHeartSize
        
        for columns in 1...20 { // Reasonable range for columns
            let heartWidth = (availableWidth - (spacing * CGFloat(columns - 1))) / CGFloat(columns)
            let rows = Int(ceil(Double(totalItems) / Double(columns)))
            let heartHeight = (availableHeight - (spacing * CGFloat(rows - 1))) / CGFloat(rows)
            let heartSize = min(heartWidth, heartHeight)
            
            // Prefer larger hearts that still fit
            if heartSize >= minHeartSize && heartSize <= maxHeartSize && heartSize > bestHeartSize {
                bestHeartSize = heartSize
                bestColumns = columns
            }
        }
        
        // If no good fit found, use minimum size
        if bestHeartSize < minHeartSize {
            bestHeartSize = minHeartSize
            bestColumns = min(Int(availableWidth / (minHeartSize + spacing)), 20)
        }
        
        return (bestColumns, bestHeartSize)
    }
    
    private func heartType(for index: Int) -> String {
        // Use pre-generated random layout
        return randomHeartTypes[index]
    }
    
    private func isElementVisible(index: Int, totalItems: Int, remainingItems: Int, columns: Int) -> Bool {
        // Calculate row and column for this index
        let row = index / columns
        let col = index % columns
        
        // Calculate total rows
        let totalRows = Int(ceil(Double(totalItems) / Double(columns)))
        
        // Calculate how many complete rows should be visible
        let completeVisibleRows = remainingItems / columns
        
        // Calculate how many items should be visible in the partial row
        let itemsInPartialRow = remainingItems % columns
        
        // Element is visible if:
        // 1. It's in a complete visible row, OR
        // 2. It's in the partial row and within the visible items
        if row < completeVisibleRows {
            return true
        } else if row == completeVisibleRows && col < itemsInPartialRow {
            return true
        } else {
            return false
        }
    }
    
    private static func calculateScaledItems(totalSeconds: Int) -> Int {
        // Scale down the number of items for longer timers to maintain performance
        if totalSeconds <= 60 {
            // For 1 minute or less, use exact count
            return totalSeconds
        } else if totalSeconds <= 300 {
            // For 1-5 minutes, use 1 item per 2 seconds
            return totalSeconds / 2
        } else if totalSeconds <= 600 {
            // For 5-10 minutes, use 1 item per 3 seconds
            return totalSeconds / 3
        } else if totalSeconds <= 1200 {
            // For 10-20 minutes, use 1 item per 5 seconds
            return totalSeconds / 5
        } else {
            // For 20+ minutes, use 1 item per 10 seconds (max 300 items)
            return min(totalSeconds / 10, 300)
        }
    }
}

struct EmojiVisualView: View {
    let totalSeconds: Int
    let remainingSeconds: Int
    let isViewReady: Bool
    
    // Generate random layout once when view is created
    private let randomEmojiTypes: [String]
    
    init(totalSeconds: Int, remainingSeconds: Int, isViewReady: Bool) {
        self.totalSeconds = totalSeconds
        self.remainingSeconds = remainingSeconds
        self.isViewReady = isViewReady
        
        // Generate simple predictable emoji layout
        let scaledTotalItems = Self.calculateScaledItems(totalSeconds: totalSeconds)
        let emojiTypes = ["emoji0", "emoji1", "emoji2", "emoji3", "emoji4", "emoji5", "emoji6", "emoji7", "emoji8", "emoji9", "emoji10", "emoji11", "emoji12", "emoji13", "emoji14", "emoji15", "emoji16", "emoji17", "emoji18", "emoji19", "emoji20", "emoji21", "emoji22", "emoji23", "emoji24", "emoji25", "emoji26", "emoji27", "emoji28", "emoji29", "emoji30", "emoji31", "emoji32"]
        self.randomEmojiTypes = (0..<scaledTotalItems).map { index in
            emojiTypes[index % emojiTypes.count]
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            let isIPad = UIDevice.current.userInterfaceIdiom == .pad
            let availableWidth = geometry.size.width - (isIPad ? 180 : 40)
            let availableHeight = geometry.size.height - 20
            
            // Use pre-generated random layout
            let scaledTotalItems = randomEmojiTypes.count
            let scaledRemainingItems = Int(Double(scaledTotalItems) * (Double(remainingSeconds) / Double(totalSeconds)))
            
            let (columns, emojiSize) = calculateEmojiLayout(
                totalItems: scaledTotalItems,
                availableWidth: availableWidth,
                availableHeight: availableHeight
            )
            
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(emojiSize), spacing: 4), count: columns), spacing: 4) {
                ForEach(0..<scaledTotalItems, id: \.self) { index in
                    let displayIndex = scaledTotalItems - 1 - index
                    EmojiView(
                        isVisible: isViewReady && isElementVisible(index: displayIndex, totalItems: scaledTotalItems, remainingItems: scaledRemainingItems, columns: columns),
                        emojiType: emojiType(for: index),
                        size: emojiSize
                    )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal)
        }
    }
    
    private func calculateEmojiLayout(totalItems: Int, availableWidth: CGFloat, availableHeight: CGFloat) -> (columns: Int, emojiSize: CGFloat) {
        // Calculate optimal emoji layout - ensure exact count
        let spacing: CGFloat = 4
        let minEmojiSize: CGFloat = 12 // Minimum emoji size
        let maxEmojiSize: CGFloat = 40 // Maximum emoji size
        
        // Try different column counts to find the best fit
        var bestColumns = 1
        var bestEmojiSize: CGFloat = minEmojiSize
        
        for columns in 1...20 { // Reasonable range for columns
            let emojiWidth = (availableWidth - (spacing * CGFloat(columns - 1))) / CGFloat(columns)
            let rows = Int(ceil(Double(totalItems) / Double(columns)))
            let emojiHeight = (availableHeight - (spacing * CGFloat(rows - 1))) / CGFloat(rows)
            let emojiSize = min(emojiWidth, emojiHeight)
            
            // Prefer larger emojis that still fit
            if emojiSize >= minEmojiSize && emojiSize <= maxEmojiSize && emojiSize > bestEmojiSize {
                bestEmojiSize = emojiSize
                bestColumns = columns
            }
        }
        
        // If no good fit found, use minimum size
        if bestEmojiSize < minEmojiSize {
            bestEmojiSize = minEmojiSize
            bestColumns = min(Int(availableWidth / (minEmojiSize + spacing)), 20)
        }
        
        return (bestColumns, bestEmojiSize)
    }
    
    private func emojiType(for index: Int) -> String {
        // Use pre-generated random layout
        return randomEmojiTypes[index]
    }
    
    private func isElementVisible(index: Int, totalItems: Int, remainingItems: Int, columns: Int) -> Bool {
        // Calculate row and column for this index
        let row = index / columns
        let col = index % columns
        
        // Calculate total rows
        let totalRows = Int(ceil(Double(totalItems) / Double(columns)))
        
        // Calculate how many complete rows should be visible
        let completeVisibleRows = remainingItems / columns
        
        // Calculate how many items should be visible in the partial row
        let itemsInPartialRow = remainingItems % columns
        
        // Element is visible if:
        // 1. It's in a complete visible row, OR
        // 2. It's in the partial row and within the visible items
        if row < completeVisibleRows {
            return true
        } else if row == completeVisibleRows && col < itemsInPartialRow {
            return true
        } else {
            return false
        }
    }
    
    private static func calculateScaledItems(totalSeconds: Int) -> Int {
        // Scale down the number of items for longer timers to maintain performance
        if totalSeconds <= 60 {
            // For 1 minute or less, use exact count
            return totalSeconds
        } else if totalSeconds <= 300 {
            // For 1-5 minutes, use 1 item per 2 seconds
            return totalSeconds / 2
        } else if totalSeconds <= 600 {
            // For 5-10 minutes, use 1 item per 3 seconds
            return totalSeconds / 3
        } else if totalSeconds <= 1200 {
            // For 10-20 minutes, use 1 item per 5 seconds
            return totalSeconds / 5
        } else {
            // For 20+ minutes, use 1 item per 10 seconds (max 300 items)
            return min(totalSeconds / 10, 300)
        }
    }
}

#Preview {
    NavigationView {
        VisualTimerView(totalSeconds: 300, visualType: .bricks) // 5 minutes
    }
} 
