import Combine
import UIKit
import WidgetKit

final class BatteryMonitor: ObservableObject {
    @Published var isCharging: Bool
    @Published var batteryLevel: Float

    init() {
        isCharging = ProcessInfo.processInfo.powerState.isCharging
        batteryLevel = UIDevice.current.batteryLevel
        UIDevice.current.isBatteryMonitoringEnabled = true

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(powerChanged),
            name: .NSProcessInfoPowerStateDidChange,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(powerChanged),
            name: UIDevice.batteryStateDidChangeNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(powerChanged),
            name: UIDevice.batteryLevelDidChangeNotification,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func powerChanged() {
        isCharging = ProcessInfo.processInfo.powerState.isCharging
        batteryLevel = UIDevice.current.batteryLevel
        WidgetCenter.shared.reloadTimelines(ofKind: AppGroupStore.kind)
    }
}
