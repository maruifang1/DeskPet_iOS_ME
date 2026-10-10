import Combine
import UIKit
import WidgetKit

final class BatteryMonitor: ObservableObject {
    @Published var isCharging: Bool
    @Published var batteryLevel: Float

    init() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        let state = UIDevice.current.batteryState
        isCharging = state == .charging || state == .full
        batteryLevel = UIDevice.current.batteryLevel

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
        isCharging = isDeviceCharging
        batteryLevel = UIDevice.current.batteryLevel
        WidgetCenter.shared.reloadTimelines(ofKind: AppGroupStore.kind)
    }

    private var isDeviceCharging: Bool {
        let state = UIDevice.current.batteryState
        return state == .charging || state == .full
    }
}
