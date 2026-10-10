import Foundation

enum PetMood: String, Codable, CaseIterable {
    case morning, noon, afternoon, evening, night
    case charging, lowBattery
    case reactHappy, reactSurprised, reactSleepy

    var frameName: String {
        "frame.\(rawValue)"
    }

    var displayName: String {
        switch self {
        case .morning: return "清晨"
        case .noon: return "午间"
        case .afternoon: return "下午"
        case .evening: return "傍晚"
        case .night: return "深夜"
        case .charging: return "充电中"
        case .lowBattery: return "低电量"
        case .reactHappy: return "开心"
        case .reactSurprised: return "惊讶"
        case .reactSleepy: return "困了"
        }
    }
}
