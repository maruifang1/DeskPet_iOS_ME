import Foundation

enum AppGroupStore {
    static let suiteName = "group.com.example.deskpet"
    static let kind = "DeskPetWidget"

    private enum Key {
        static let moodOverride = "moodOverride"
        static let reactAt = "reactAt"
        static let tapCount = "tapCount"
    }

    private static var defaults: UserDefaults {
        UserDefaults(suiteName: suiteName) ?? .standard
    }

    static var tapCount: Int {
        defaults.integer(forKey: Key.tapCount)
    }

    static func recordReaction(_ mood: PetMood) {
        defaults.set(mood.rawValue, forKey: Key.moodOverride)
        defaults.set(Date().timeIntervalSince1970, forKey: Key.reactAt)
        defaults.set(tapCount + 1, forKey: Key.tapCount)
    }

    static func activeReaction(now: Date = Date()) -> PetMood? {
        guard let raw = defaults.string(forKey: Key.moodOverride),
              let mood = PetMood(rawValue: raw) else {
            return nil
        }
        let reactAt = defaults.double(forKey: Key.reactAt)
        guard reactAt > 0, now.timeIntervalSince1970 - reactAt < 20 else {
            return nil
        }
        return mood
    }
}
