//
//  TimerView.swift
//  Time2See
//
//  Created by EVYATAR DAYAN on 17/07/2025.
//

import SwiftUI

struct TimerView: View {
    @State private var selectedMinutes: Int = 3
    @State private var selectedSeconds: Int = 0
    @State private var selectedVisualType: VisualType = .bricks
    @State private var showingVisualTimer = false
    @State private var showingSettings = false
    @State private var showingSettingsNavigation = false
    @State private var showingVisualTimerNavigation = false
    @EnvironmentObject var settingsManager: SettingsManager
    @Environment(\.colorScheme) var colorScheme
    
    private var isIPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    private var localizedText: (String) -> String {
        return { key in
            LocalizationManager.shared.localizedString(key, language: settingsManager.selectedLanguage)
        }
    }
    
    enum VisualType: String, CaseIterable {
        case bricks = "Bricks"
        case circle = "Circle"
        case square = "Square"
        case bubbles = "Balloons"
        case candies = "Candies"
        case balls = "Balls"
        case triangle = "Triangle"
        case hexagon = "Hexagon"
        case star = "Star"
        case battery = "Battery"
        case hearts = "Hearts"
        case emoji = "Emoji"
        case toys = "Toys"
        
        var icon: String {
            switch self {
            case .bricks:
                return "square.grid.3x3.fill"
            case .circle:
                return "circle.fill"
            case .square:
                return "square.fill"
            case .bubbles:
                return "balloon.fill"
            case .candies:
                return "heart.fill"
            case .balls:
                return "circle.fill"
            case .triangle:
                return "triangle.fill"
            case .hexagon:
                return "hexagon.fill"
            case .star:
                return "star.fill"
            case .battery:
                return "battery.100"
            case .hearts:
                return "heart.fill"
            case .emoji:
                return "face.smiling"
            case .toys:
                return "gamecontroller.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .bricks:
                return .blue
            case .circle:
                return .green
            case .square:
                return .purple
            case .bubbles:
                return .red
            case .candies:
                return .pink
            case .balls:
                return .orange
            case .triangle:
                return .indigo
            case .hexagon:
                return .teal
            case .star:
                return .yellow
            case .battery:
                return .green
            case .hearts:
                return .pink
            case .emoji:
                return .orange
            case .toys:
                return .brown
            }
        }
    }
    
    var body: some View {
        ZStack {
            // Background image for main timer view
//            Image(isIPad ? "MainTimerIpad" : "MainTimer")
            Image(isIPad ? "SquarePatternIpad" : "SquarePattern")
                .resizable()
                .ignoresSafeArea()
                .opacity(0.05)
            
            VStack(spacing: isIPad ? 50 : 30) {
                // Header
                VStack(spacing: isIPad ? 20 : 10) {
                
                HStack(spacing: 0) {
                    Text("Time")
                        .font(.system(size: isIPad ? 80 : 50, weight: .bold))
                        .foregroundColor(.blue)
                    Text("2See")
                        .font(.system(size: isIPad ? 80 : 50, weight: .bold))
                        .foregroundColor(.green)
                }
                .padding(.top, 40)
            }
            
            // Time Display
            VStack(spacing: isIPad ? 25 : 15) {
                
                Text(String(format: "%02d:%02d", selectedMinutes, selectedSeconds))
                    .font(.system(size: isIPad ? 72 : 48, weight: .bold, design: .monospaced))
                    .foregroundColor(.primary)
                    .padding(.horizontal, isIPad ? 40 : 20)
                    .padding(.vertical, isIPad ? 20 : 10)
                    .background(
                        RoundedRectangle(cornerRadius: isIPad ? 20 : 15)
                            .fill(Color.blue.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: isIPad ? 20 : 15)
                                    .stroke(Color.blue.opacity(0.3), lineWidth: isIPad ? 3 : 2)
                            )
                    )
            }
            
            // Time Picker
            VStack(spacing: isIPad ? 30 : 20) {
                
                HStack(spacing: isIPad ? 60 : 30) {
                    // Minutes Picker
                    VStack {
                        Picker("", selection: $selectedMinutes) {
                            ForEach(0...60, id: \.self) { minute in
                                HStack {
                                    Text("\(minute)")
                                        .font(.system(size: isIPad ? 24 : 18, weight: .bold))
                                        .foregroundColor(.primary)
                                    Text("Min")
                                        .font(.system(size: isIPad ? 16 : 14, weight: .medium))
                                        .foregroundColor(.primary)
                                }
                                .tag(minute)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: isIPad ? 150 : 100, height: isIPad ? 180 : 140)
                        .clipped()
                    }
                    
                    // Seconds Picker
                    VStack {
                        Picker("", selection: $selectedSeconds) {
                            ForEach(0...59, id: \.self) { second in
                                HStack {
                                    Text("\(second)")
                                        .font(.system(size: isIPad ? 24 : 18, weight: .bold))
                                        .foregroundColor(.primary)
                                    Text("Sec")
                                        .font(.system(size: isIPad ? 16 : 14, weight: .medium))
                                        .foregroundColor(.primary)
                                }
                                .tag(second)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: isIPad ? 150 : 100, height: isIPad ? 180 : 140)
                        .clipped()
                    }
                }
                
                // Preset Time Buttons
                HStack(spacing: isIPad ? 20 : 8) {
                    ForEach([2, 5, 10, 20, 30], id: \.self) { minutes in
                        Button(action: {
                            selectedMinutes = minutes
                            selectedSeconds = 0
                        }) {
                            Text("\(minutes) min")
                                .font(.system(size: isIPad ? 18 : 12, weight: .medium))
                                .foregroundColor(.white)
                                .padding(.horizontal, isIPad ? 16 : 12)
                                .padding(.vertical, isIPad ? 12 : 10)
                                .background(
                                    RoundedRectangle(cornerRadius: isIPad ? 12 : 8)
                                        .fill(Color.blue)
                                )
                        }
                    }
                }
            }
            
            // Visual Type Carousels
            VStack(spacing: isIPad ? 25 : 15) {
                // First row - Grid-based visuals
                VStack(spacing: isIPad ? 25 : 15) {
                    Text(localizedText("timer_style"))
                        .font(isIPad ? .title2 : .headline)
                        .foregroundColor(.secondary)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: isIPad ? 25 : 15) {
                            ForEach([VisualType.bricks, VisualType.bubbles, VisualType.candies, VisualType.balls, VisualType.hearts, VisualType.emoji, VisualType.toys], id: \.self) { visualType in
                                VisualTypeCard(
                                    visualType: visualType,
                                    isSelected: selectedVisualType == visualType
                                ) {
                                    selectedVisualType = visualType
                                }
                            }
                        }
                        .padding(.horizontal)
                        .frame(height: isIPad ? 140 : 100) // Increased height for uniform frame
                    }
                }
                
                // Second row - Shape-based visuals
                VStack(spacing: isIPad ? 25 : 15) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: isIPad ? 25 : 15) {
                            ForEach([VisualType.circle, VisualType.square, VisualType.triangle, VisualType.hexagon, VisualType.star, VisualType.battery], id: \.self) { visualType in
                                VisualTypeCard(
                                    visualType: visualType,
                                    isSelected: selectedVisualType == visualType
                                ) {
                                    selectedVisualType = visualType
                                }
                            }
                        }
                        .padding(.horizontal)
                        .frame(height: isIPad ? 140 : 100) // Increased height for uniform frame
                    }
                }
            }
            
            // Start Button
            Button(action: {
                if isIPad {
                    // For iPad, use navigation push
                    showingVisualTimerNavigation = true
                } else {
                    // For iPhone, use modal
                    showingVisualTimer = true
                }
            }) {
                Text(localizedText("start_timer"))
                    .font(isIPad ? .title : .title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: isIPad ? 400 : .infinity)
                    .padding(isIPad ? 20 : 16)
                    .background(
                        RoundedRectangle(cornerRadius: isIPad ? 20 : 15)
                            .fill(Color.blue)
                    )
            }
            .disabled(selectedMinutes == 0 && selectedSeconds == 0)
            .opacity(selectedMinutes == 0 && selectedSeconds == 0 ? 0.5 : 1.0)
            .padding(.horizontal)
            .padding(.bottom, isIPad ? 50 : 30) // Added extra bottom padding
        }
        .padding(isIPad ? 40 : 20)
        .navigationBarHidden(true)
        .id(settingsManager.selectedLanguage) // Force view update when language changes
        .sheet(isPresented: $showingVisualTimer) {
            VisualTimerView(
                totalSeconds: selectedMinutes * 60 + selectedSeconds,
                visualType: selectedVisualType,
                isIPad: false
            )
        }
        .overlay(
            // Settings button positioned independently in top right
            VStack {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        if isIPad {
                            // For iPad, use navigation push
                            showingSettingsNavigation = true
                        } else {
                            // For iPhone, use modal
                            showingSettings = true
                        }
                    }) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: isIPad ? 30 : 20))
                            .foregroundColor(.blue)
                            .padding(8)
                            .background(
                                Circle()
                                    .fill(Color.white.opacity(0.9))
                                    .shadow(radius: 2)
                            )
                    }
                }
                .padding(.top, isIPad ? 90 : 40)
                .padding(.horizontal, isIPad ? 40 : 20)
                
                Spacer()
            }
        )
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .background(
            // Hidden NavigationLink for iPad settings
            NavigationLink(
                destination: SettingsView(isIPad: true)
                    .navigationBarTitleDisplayMode(.large)
                    .navigationBarBackButtonHidden(true)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(localizedText("done")) {
                                showingSettingsNavigation = false
                            }
                        }
                    }
                    .navigationViewStyle(StackNavigationViewStyle()),
                isActive: $showingSettingsNavigation
            ) {
                EmptyView()
            }
            .hidden()
        )
        .background(
            // Hidden NavigationLink for iPad visual timer
            NavigationLink(
                destination: VisualTimerView(
                    totalSeconds: selectedMinutes * 60 + selectedSeconds,
                    visualType: selectedVisualType,
                    isIPad: true
                )
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(localizedText("done")) {
                            showingVisualTimerNavigation = false
                        }
                    }
                }
                .navigationViewStyle(StackNavigationViewStyle()),
                isActive: $showingVisualTimerNavigation
            ) {
                EmptyView()
            }
            .hidden()
        )
        }
    }
}

struct VisualTypeCard: View {
    let visualType: TimerView.VisualType
    let isSelected: Bool
    let action: () -> Void
    @EnvironmentObject var settingsManager: SettingsManager
    
    private var isIPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    private var localizedText: (String) -> String {
        return { key in
            LocalizationManager.shared.localizedString(key, language: settingsManager.selectedLanguage)
        }
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                if visualType == .bricks {
                    Image("brick")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: isIPad ? 45 : 30, height: isIPad ? 45 : 30)
                        .foregroundColor(isSelected ? .white : visualType.color)
                } else if visualType == .bubbles {
                    Image("balloon2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: isIPad ? 45 : 30, height: isIPad ? 45 : 30)
                        .foregroundColor(isSelected ? .white : visualType.color)
                } else if visualType == .circle {
                    // Custom circle with gradient matching visual timer
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.green, .orange, .red]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: isIPad ? 45 : 30, height: isIPad ? 45 : 30)
                        .overlay(
                            Circle()
                                .stroke(isSelected ? .white : visualType.color, lineWidth: isIPad ? 3 : 2)
                        )
                } else if visualType == .square {
                    // Custom square with gradient matching visual timer
                    RoundedRectangle(cornerRadius: isIPad ? 6 : 4)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.green, .orange, .red]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: isIPad ? 45 : 30, height: isIPad ? 45 : 30)
                        .overlay(
                            RoundedRectangle(cornerRadius: isIPad ? 6 : 4)
                                .stroke(isSelected ? .white : visualType.color, lineWidth: isIPad ? 3 : 2)
                        )
                } else if visualType == .candies {
                    Image("candy1")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: isIPad ? 45 : 30, height: isIPad ? 45 : 30)
                        .foregroundColor(isSelected ? .white : visualType.color)
                } else if visualType == .balls {
                    Image("ball3")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: isIPad ? 45 : 30, height: isIPad ? 45 : 30)
                        .foregroundColor(isSelected ? .white : visualType.color)
                } else if visualType == .hearts {
                    Image("heart1")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: isIPad ? 45 : 30, height: isIPad ? 45 : 30)
                        .foregroundColor(isSelected ? .white : visualType.color)
                } else if visualType == .emoji {
                    Image("emoji16")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: isIPad ? 45 : 30, height: isIPad ? 45 : 30)
                        .foregroundColor(isSelected ? .white : visualType.color)
                } else if visualType == .toys {
                    Image("toy1")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: isIPad ? 45 : 30, height: isIPad ? 45 : 30)
                        .foregroundColor(isSelected ? .white : visualType.color)
                } else if visualType == .triangle {
                    // Custom triangle with gradient matching visual timer
                    Triangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.green, .orange, .red]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: isIPad ? 45 : 30, height: isIPad ? 45 : 30)
                        .overlay(
                            Triangle()
                                .stroke(isSelected ? .white : visualType.color, lineWidth: isIPad ? 3 : 2)
                        )
                } else if visualType == .hexagon {
                    // Custom hexagon with gradient matching visual timer
                    Hexagon()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.green, .orange, .red]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: isIPad ? 45 : 30, height: isIPad ? 45 : 30)
                        .overlay(
                            Hexagon()
                                .stroke(isSelected ? .white : visualType.color, lineWidth: isIPad ? 3 : 2)
                        )
                } else if visualType == .star {
                    // Custom star with gradient matching visual timer
                    Star()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.green, .orange, .red]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: isIPad ? 45 : 30, height: isIPad ? 45 : 30)
                        .overlay(
                            Star()
                                .stroke(isSelected ? .white : visualType.color, lineWidth: isIPad ? 3 : 2)
                        )
                } else if visualType == .battery {
                    // Custom battery with gradient matching visual timer
                    Battery()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.green, .orange, .red]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: isIPad ? 45 : 30, height: isIPad ? 45 : 30)
                        .overlay(
                            Battery()
                                .stroke(isSelected ? .white : visualType.color, lineWidth: isIPad ? 3 : 2)
                        )
                } else {
                    Image(systemName: visualType.icon)
                        .font(.system(size: isIPad ? 45 : 30))
                        .foregroundColor(isSelected ? .white : visualType.color)
                }
                
                Text(localizedText(visualType.rawValue))
                    .font(isIPad ? .body : .caption)
                    .fontWeight(.medium)
                    .foregroundColor(settingsManager.isDarkMode ? .white : .blue)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .frame(width: isIPad ? 120 : 80, height: isIPad ? 120 : 80)
            .background(
                RoundedRectangle(cornerRadius: isIPad ? 18 : 12)
                    .fill(Color.gray.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: isIPad ? 18 : 12)
                            .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3), lineWidth: isSelected ? (isIPad ? 4 : 3) : (isIPad ? 3 : 2))
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}



struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var settingsManager: SettingsManager

    @State private var showingHelpSupport = false
    @State private var showingTermsPrivacy = false
    @State private var showingLanguagePicker = false
    @State private var showingAbout = false
    
    let isIPad: Bool
    
    init(isIPad: Bool = false) {
        self.isIPad = isIPad
    }
    
    private var localizedText: (String) -> String {
        return { key in
            LocalizationManager.shared.localizedString(key, language: settingsManager.selectedLanguage)
        }
    }
    
    var body: some View {
        NavigationView {
            List {

                
                // Language Section
                Section(localizedText("language")) {
                    HStack(spacing: 8) {
                        Image(systemName: "globe")
                            .foregroundColor(.blue)
                            .frame(width: 25)
                        
                        Text(localizedText("language"))
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                        
                        Spacer(minLength: 8)
                        
                        Button(action: {
                            showingLanguagePicker = true
                        }) {
                            HStack {
                                Text(settingsManager.selectedLanguage.flag)
                                Text(settingsManager.selectedLanguage.displayName)
                                Image(systemName: "chevron.down")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .foregroundColor(.primary)
                    }
                    .padding(.horizontal, isIPad ? 20 : 0)
                }
                
                // Appearance Section
                Section("Appearance") {
                    HStack(spacing: 8) {
                        Image(systemName: "moon.fill")
                            .foregroundColor(.purple)
                            .frame(width: 25)
                        
                        Text(localizedText("dark_mode"))
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                        
                        Spacer(minLength: 8)
                        
                        Toggle("", isOn: $settingsManager.isDarkMode)
                    }
                    .padding(.horizontal, isIPad ? 20 : 0)
                }
                
                // Support Section
                Section("Support") {
                    Button(action: {
                        showingHelpSupport = true
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "questionmark.circle.fill")
                                .foregroundColor(.green)
                                .frame(width: 25)
                            
                            Text(localizedText("help_support"))
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                            
                            Spacer(minLength: 8)
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                                .font(.caption)
                        }
                    }
                    .foregroundColor(.primary)
                    .padding(.horizontal, isIPad ? 20 : 0)
                }
                
                // Legal Section
                Section("Legal") {
                    Button(action: {
                        showingTermsPrivacy = true
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "doc.text.fill")
                                .foregroundColor(.orange)
                                .frame(width: 25)
                            
                            Text(localizedText("terms_privacy"))
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                            
                            Spacer(minLength: 8)
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                                .font(.caption)
                        }
                    }
                    .foregroundColor(.primary)
                    .padding(.horizontal, isIPad ? 20 : 0)
                    

                }
                
                // About Section
                Section("About") {
                    Button(action: {
                        showingAbout = true
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(.blue)
                                .frame(width: 25)
                            
                            Text("About")
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                            
                            Spacer(minLength: 8)
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                                .font(.caption)
                        }
                    }
                    .foregroundColor(.primary)
                    .padding(.horizontal, isIPad ? 20 : 0)
                }
                

            }
            .navigationTitle(localizedText("settings"))
            .navigationBarTitleDisplayMode(.inline)
            .id(settingsManager.selectedLanguage) // Force view update when language changes
            .toolbar {
                if !isIPad {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(localizedText("done")) {
                            dismiss()
                        }
                    }
                }
            }

            .sheet(isPresented: $showingHelpSupport) {
                HelpSupportView()
            }
            .sheet(isPresented: $showingTermsPrivacy) {
                TermsPrivacyView()
            }
            .sheet(isPresented: $showingLanguagePicker) {
                LanguagePickerView(selectedLanguage: $settingsManager.selectedLanguage)
            }
            .sheet(isPresented: $showingAbout) {
                AboutView()
            }
        }
    }
    

}

struct HelpSupportView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var settingsManager: SettingsManager
    @State private var showingContactForm = false
    
    private var localizedText: (String) -> String {
        return { key in
            LocalizationManager.shared.localizedString(key, language: settingsManager.selectedLanguage)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Spacer()
                
                // Opening message
                VStack(spacing: 15) {
                    Text(localizedText("we_love_to_hear"))
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text(localizedText("help_description"))
                        .font(.body)
                        .multilineTextAlignment(.center)
                }
                
                .padding(.top, 20)
                .padding(.horizontal, 20)
                .padding(.bottom, 50)
                
//                Spacer()
                
                Spacer()
                
                Spacer()
                
                // Contact form button
                Button(action: {
                    showingContactForm = true
                }) {
                    Text(localizedText("contact_form"))
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.green)
                        )
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Response time message
                Text(localizedText("response_time"))
                    .font(.body)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                Spacer()
            }
            .navigationTitle(localizedText("help_support_title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(localizedText("close")) {
                        dismiss()
                    }
                    .foregroundColor(.blue)
                }
            }
            .sheet(isPresented: $showingContactForm) {
                ContactFormView()
            }
            .id(settingsManager.selectedLanguage) // Force view update when language changes
        }
    }
}

struct ContactFormView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var settingsManager: SettingsManager
    @State private var fullName = ""
    @State private var email = ""
    @State private var subject = ""
    @State private var description = ""
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var showValidation = false
    @State private var showingSuccessAlert = false
    
    private var localizedText: (String) -> String {
        return { key in
            LocalizationManager.shared.localizedString(key, language: settingsManager.selectedLanguage)
        }
    }
    
    // Validation computed properties
    private var isFullNameValid: Bool {
        let words = fullName.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .whitespaces)
        return words.count >= 2 && words.allSatisfy { !$0.isEmpty }
    }
    
    private var isEmailValid: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email.trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
    private var isSubjectValid: Bool {
        return subject.trimmingCharacters(in: .whitespacesAndNewlines).count >= 5
    }
    
    private var isDescriptionValid: Bool {
        return description.trimmingCharacters(in: .whitespacesAndNewlines).count >= 5
    }
    
    private var isFormValid: Bool {
        return isFullNameValid && isEmailValid && isSubjectValid && isDescriptionValid
    }
    
    private func handleSend() {
        showValidation = true
        if isFormValid {
            // Handle send action
            showingSuccessAlert = true
        }
    }
    
    private func getImageFileName() -> String {
        // Since we don't have the original filename from UIImagePickerController,
        // we'll use a generic name with timestamp
        let timestamp = Int(Date().timeIntervalSince1970)
        let fileName = "image_\(timestamp).jpg"
        
        // Limit to 20 characters
        if fileName.count > 20 {
            let startIndex = fileName.startIndex
            let endIndex = fileName.index(startIndex, offsetBy: 17)
            return String(fileName[startIndex..<endIndex]) + "..."
        }
        return fileName
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                ScrollView {
                    VStack(spacing: 20) {
                        // Full Name Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text(localizedText("full_name").uppercased())
                                .font(.caption)
                                .foregroundColor(.gray)
                                .fontWeight(.medium)
                            
                            TextField(localizedText("full_name_placeholder"), text: $fullName)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.words)
                                .disableAutocorrection(true)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.white)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(showValidation && !isFullNameValid ? Color.red : Color.gray.opacity(0.3), lineWidth: 1)
                                        )
                                )
                            
                            if showValidation && !isFullNameValid {
                                Text(localizedText("validation_full_name"))
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                        
                        // Email Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text(localizedText("email").uppercased())
                                .font(.caption)
                                .foregroundColor(.gray)
                                .fontWeight(.medium)
                            
                            TextField(localizedText("email_placeholder"), text: $email)
                                .keyboardType(.emailAddress)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.white)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(showValidation && !isEmailValid ? Color.red : Color.gray.opacity(0.3), lineWidth: 1)
                                        )
                                )
                            
                            if showValidation && !isEmailValid {
                                Text(localizedText("validation_email"))
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                        
                        // Subject Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text(localizedText("subject").uppercased())
                                .font(.caption)
                                .foregroundColor(.gray)
                                .fontWeight(.medium)
                            
                            ZStack(alignment: .bottomTrailing) {
                                TextField(localizedText("subject_placeholder"), text: $subject)
                                    .autocorrectionDisabled()
                                    .textInputAutocapitalization(.sentences)
                                    .disableAutocorrection(true)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.white)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(showValidation && !isSubjectValid ? Color.red : Color.gray.opacity(0.3), lineWidth: 1)
                                            )
                                    )
                                
                                Text("\(subject.count)/100")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                                    .padding(.bottom, 4)
                            }
                            
                            if showValidation && !isSubjectValid {
                                Text(localizedText("validation_subject"))
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                        
                        // Description Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text(localizedText("description").uppercased())
                                .font(.caption)
                                .foregroundColor(.gray)
                                .fontWeight(.medium)
                            
                            ZStack(alignment: .bottomTrailing) {
                                TextEditor(text: $description)
                                    .autocorrectionDisabled()
                                    .textInputAutocapitalization(.sentences)
                                    .disableAutocorrection(true)
                                    .frame(minHeight: 120)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.white)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(showValidation && !isDescriptionValid ? Color.red : Color.gray.opacity(0.3), lineWidth: 1)
                                            )
                                    )
                                
                                Text("\(description.count)/400")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                                    .padding(.bottom, 4)
                            }
                            
                            if showValidation && !isDescriptionValid {
                                Text(localizedText("validation_description"))
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                        
                        // Add/Update Image Button
                        Button(action: {
                            showingImagePicker = true
                        }) {
                            HStack {
                                if selectedImage != nil {
                                    // Show thumbnail and filename when image is selected
                                    HStack(spacing: 12) {
                                        Text(localizedText("update"))
                                            .foregroundColor(.green)
                                            .fontWeight(.medium)
                                        
                                        Spacer()
                                        
                                        Text(getImageFileName())
                                            .foregroundColor(.gray)
                                            .font(.body)
                                        
                                        // Thumbnail
                                        Image(uiImage: selectedImage!)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 40, height: 40)
                                            .clipShape(RoundedRectangle(cornerRadius: 6))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 6)
                                                    .stroke(Color.green, lineWidth: 1)
                                            )
                                    }
                                } else {
                                    // Show "Add image" when no image is selected
                                    HStack {
                                        Text(localizedText("add_image"))
                                            .foregroundColor(.green)
                                            .fontWeight(.medium)
                                        Spacer()
                                    }
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
                
                // Send Button
                Button(action: handleSend) {
                    Text(localizedText("send"))
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.blue)
                        )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .navigationTitle(localizedText("contact_us_title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(localizedText("close")) {
                        dismiss()
                    }
                    .foregroundColor(.blue)
                }
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
        .alert(localizedText("success_title"), isPresented: $showingSuccessAlert) {
            Button(localizedText("ok")) {
                dismiss()
            }
        } message: {
            Text(localizedText("success_message"))
        }
        .id(settingsManager.selectedLanguage) // Force view update when language changes
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        // Start at the top point (apex)
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        // Draw line to bottom right
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        // Draw line to bottom left
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        // Close the path back to the top
        path.closeSubpath()
        return path
    }
}

struct Hexagon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        let centerX = width / 2
        let centerY = height / 2
        let radius = min(width, height) / 2
        
        // Calculate the six points of the hexagon
        for i in 0..<6 {
            let angle = Double(i) * .pi / 3 - .pi / 6 // Start from top point
            let x = centerX + radius * cos(angle)
            let y = centerY + radius * sin(angle)
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        path.closeSubpath()
        return path
    }
}

struct Star: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        let centerX = width / 2
        let centerY = height / 2
        let outerRadius = min(width, height) / 2
        let innerRadius = outerRadius * 0.4 // Inner radius for star points
        
        // Create a 5-pointed star
        for i in 0..<10 {
            let angle = Double(i) * .pi / 5 - .pi / 2 // Start from top point
            let radius = i % 2 == 0 ? outerRadius : innerRadius
            let x = centerX + radius * cos(angle)
            let y = centerY + radius * sin(angle)
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        path.closeSubpath()
        return path
    }
}

struct Battery: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        
        // Main battery body (rounded rectangle) - rotated 90 degrees
        let bodyWidth = height * 0.85  // Use height for width since rotated
        let bodyHeight = width * 1.2   // Make it taller for more realistic battery look
        let cornerRadius = min(width, height) * 0.1
        
        let bodyRect = CGRect(
            x: (width - bodyWidth) / 2,
            y: (height - bodyHeight) / 2,
            width: bodyWidth,
            height: bodyHeight
        )
        
        // Draw main battery body
        path.addRoundedRect(in: bodyRect, cornerSize: CGSize(width: cornerRadius, height: cornerRadius))
        
        // Add positive terminal (small rectangle on the top)
        let terminalWidth = width * 0.3
        let terminalHeight = height * 0.08
        let terminalX = bodyRect.midX - terminalWidth / 2
        let terminalY = bodyRect.minY - terminalHeight
        
        let terminalRect = CGRect(
            x: terminalX,
            y: terminalY,
            width: terminalWidth,
            height: terminalHeight
        )
        
        path.addRect(terminalRect)
        
        return path
    }
}

struct TermsPrivacyView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var settingsManager: SettingsManager
    @State private var selectedTab = 0
    
    private var localizedText: (String) -> String {
        return { key in
            LocalizationManager.shared.localizedString(key, language: settingsManager.selectedLanguage)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Segmented Control
                Picker("Content Type", selection: $selectedTab) {
                    Text("Terms of Use").tag(0)
                    Text("Privacy Policy").tag(1)
                    Text("Disclaimer").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Content based on selected tab
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        switch selectedTab {
                        case 0:
                            termsOfUseContent
                        case 1:
                            privacyPolicyContent
                        case 2:
                            disclaimerContent
                        default:
                            termsOfUseContent
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Terms & Privacy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(localizedText("close")) {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var termsOfUseContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Effective Date: 21/07/2025")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text("Welcome to Time2See! These Terms of Use ('Terms') govern your use of the Time2See application (\"the App\"), designed to help children understand the passage of time through visual representation.")
                .font(.body)
            
            Text("By using Time2See, you agree to these Terms. If you do not agree, please do not use the App.")
                .font(.body)
                .padding(.bottom, 8)
            
            Text("1. Purpose of the App")
                .font(.headline)
                .fontWeight(.bold)
            Text("Time2See is intended for educational and entertainment purposes only. It provides a simple and friendly way to help children visualize time in a clear and interactive manner.")
                .font(.body)
            
            Text("2. Who Can Use the App")
                .font(.headline)
                .fontWeight(.bold)
            Text("The App is designed for use by children with the supervision or permission of a parent, guardian, or educator. By using Time2See, you confirm that you are either:")
                .font(.body)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("• A parent or legal guardian supervising the use of the App, or")
                    .font(.body)
                Text("• Over the age of 13 and using the App for its intended educational purpose.")
                    .font(.body)
            }
            .padding(.leading, 16)
            
            Text("3. User Data and Privacy")
                .font(.headline)
                .fontWeight(.bold)
            Text("We care about your privacy. Time2See does not collect any personal information from users. For more details, please refer to our Privacy Policy.")
                .font(.body)
            
            Text("4. Intellectual Property")
                .font(.headline)
                .fontWeight(.bold)
            Text("All content in Time2See, including design, graphics, and features, are the property of the app developer and protected by applicable copyright and intellectual property laws.")
                .font(.body)
            
            Text("5. No Warranty")
                .font(.headline)
                .fontWeight(.bold)
            Text("Time2See is provided \"as is\" without warranty of any kind. We do our best to ensure the App works smoothly, but we do not guarantee it will be free of bugs or interruptions.")
                .font(.body)
            
            Text("6. Changes to the Terms")
                .font(.headline)
                .fontWeight(.bold)
            Text("We may update these Terms from time to time. Continued use of Time2See after changes are made means you agree to the updated Terms.")
                .font(.body)
        }
    }
    
    private var privacyPolicyContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Effective Date: 21/07/2025")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text("Your privacy is important to us. This Privacy Policy explains how the Time2See app handles your information.")
                .font(.body)
                .padding(.bottom, 8)
            
            Text("1. No Personal Data Collection")
                .font(.headline)
                .fontWeight(.bold)
            Text("Time2See does not collect, store, or share any personal information. We do not ask for names, email addresses, location data, or any other personally identifiable information.")
                .font(.body)
            
            Text("2. No Internet Connection Required")
                .font(.headline)
                .fontWeight(.bold)
            Text("Time2See is a fully offline app. It does not require an internet connection to function and does not connect to external servers or services.")
                .font(.body)
            
            Text("3. No Third-Party Analytics or Advertising")
                .font(.headline)
                .fontWeight(.bold)
            Text("We do not use third-party analytics tools or serve any advertisements within the app. There are no hidden trackers, cookies, or data collection mechanisms.")
                .font(.body)
            
            Text("4. Children's Privacy")
                .font(.headline)
                .fontWeight(.bold)
            Text("Time2See is designed with children in mind and complies with privacy principles intended to protect minors. Since the app collects no data, it is safe for use by children under the supervision of a parent or guardian.")
                .font(.body)
            
            Text("5. Changes to This Policy")
                .font(.headline)
                .fontWeight(.bold)
            Text("If we ever update this policy, we will revise the \"Effective Date\" and make the new version available through the app or app store listing. We encourage you to review it occasionally.")
                .font(.body)
        }
    }
    
    private var disclaimerContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Time2See may include images or visual elements that are sourced from third-party creators or publicly available resources. We do not claim ownership of such third-party content unless explicitly stated.")
                .font(.body)
            
            Text("All intellectual property rights for third-party images or media used in the app belong to their respective creators and copyright holders. If you are the owner of any content featured in the app and believe it has been used without proper attribution or permission, please contact us immediately and we will address the matter promptly.")
                .font(.body)
            
            Text("Use of any third-party content in Time2See is for educational or illustrative purposes only and is not intended to infringe upon the rights of any copyright holder.")
                .font(.body)
        }
    }
}



struct LanguagePickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedLanguage: AppLanguage
    
    var body: some View {
        NavigationView {
            List {
                ForEach(AppLanguage.allCases, id: \.self) { language in
                    Button(action: {
                        selectedLanguage = language
                        dismiss()
                    }) {
                        HStack {
                            Text(language.flag)
                                .font(.title2)
                            Text(language.displayName)
                                .font(.body)
                                .foregroundColor(.primary)
                            Spacer()
                            if selectedLanguage == language {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                                    .font(.body)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                        .padding(.vertical, 8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .navigationTitle("Select Language")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("\"ABASHELARI\" is a creative software studio dedicated to building playful, purposeful, and educational apps for kids. We specialize in children's games and smart utilities that are designed to inspire curiosity, develop skills, and bring joy to everyday learning.")
                        .font(.body)
                        .multilineTextAlignment(.leading)
                    Text("From colorful timers that help children manage time to engaging games that teach letters, words, countries, and more - every \"ABASHELARI\" app is built with care, creativity, and a deep understanding of how kids learn best.")
                        .font(.body)
                        .multilineTextAlignment(.leading)
                    Text("We believe that digital experiences for children should be safe, intuitive, and enriching - and our goal is to combine fun with function in everything we create.")
                        .font(.body)
                        .multilineTextAlignment(.leading)
                    Divider().padding(.vertical, 10)
                    Text("We believe in:")
                        .font(.headline)
                        .fontWeight(.semibold)
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "paintbrush.fill").foregroundColor(.blue)
                            Text("Creative Play")
                        }
                        HStack {
                            Image(systemName: "book.fill").foregroundColor(.green)
                            Text("Educational Focus")
                        }
                        HStack {
                            Image(systemName: "lock.shield.fill").foregroundColor(.purple)
                            Text("Privacy-Respecting")
                        }
                        HStack {
                            Image(systemName: "heart.fill").foregroundColor(.pink)
                            Text("Child-Friendly Design")
                        }
                        HStack {
                            Image(systemName: "xmark.circle.fill").foregroundColor(.orange)
                            Text("No Ads, No Distractions")
                        }
                    }
                    .font(.body)
                }
                .padding()
            }
            .navigationTitle("About")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    TimerView()
} 
