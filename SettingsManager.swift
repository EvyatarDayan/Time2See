import SwiftUI

enum AppLanguage: String, CaseIterable {
    case english = "en"
    case spanish = "es"
    case swedish = "sv"
    case french = "fr"
    case german = "de"
    
    var displayName: String {
        switch self {
        case .english:
            return "English"
        case .spanish:
            return "Spanish"
        case .swedish:
            return "Swedish"
        case .french:
            return "French"
        case .german:
            return "German"
        }
    }
    
    var flag: String {
        switch self {
        case .english:
            return "🇺🇸"
        case .spanish:
            return "🇪🇸"
        case .swedish:
            return "🇸🇪"
        case .french:
            return "🇫🇷"
        case .german:
            return "🇩🇪"
        }
    }
}

class SettingsManager: ObservableObject {
    @Published var isDarkMode: Bool {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
        }
    }
    

    
    @Published var selectedLanguage: AppLanguage {
        didSet {
            UserDefaults.standard.set(selectedLanguage.rawValue, forKey: "selectedLanguage")
        }
    }
    
    init() {
        self.isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        
        // Set default language
        let savedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "en"
        self.selectedLanguage = AppLanguage(rawValue: savedLanguage) ?? .english
    }
} 