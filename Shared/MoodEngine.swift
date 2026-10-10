import Foundation
import UIKit

enum MoodEngine {
    static func mood(
        at date: Date,
        calendar: Calendar = .current,
        isCharging: Bool,
        batteryLevel: Float
    ) -> PetMood {
        if isCharging {
            return .charging
        }
        if batteryLevel >= 0, batteryLevel < 0.2 {
            return .lowBattery
        }

        let hour = calendar.component(.hour, from: date)
        switch hour {
        case 6..<11: return .morning
        case 11..<14: return .noon
        case 14..<18: return .afternoon
        case 18..<23: return .evening
        default: return .night
        }
    }

    static func currentMood() -> PetMood {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        return mood(
            at: Date(),
            isCharging: device.batteryState == .charging || device.batteryState == .full,
            batteryLevel: device.batteryLevel > 0 ? device.batteryLevel : -1
        )
    }
}
