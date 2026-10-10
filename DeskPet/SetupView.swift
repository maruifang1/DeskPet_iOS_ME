import SwiftUI
import WidgetKit

struct SetupView: View {
    @StateObject private var battery = BatteryMonitor()
    @State private var whisper = WhisperBank.todayWhisper()

    var body: some View {
        NavigationStack {
            List {
                Section("我的形象") {
                    VStack(spacing: 10) {
                        PetCharacterView(mood: MoodEngine.currentMood())
                            .frame(maxWidth: .infinity)
                        Text("当前状态：\(MoodEngine.currentMood().displayName)")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                }

                Section("状态") {
                    Label(
                        battery.isCharging ? "正在充电" : "未在充电",
                        systemImage: battery.isCharging ? "bolt.fill" : "bolt.slash"
                    )
                    Label(batteryText, systemImage: batterySymbol)
                }

                Section("今日碎念") {
                    Text(whisper)
                    Button {
                        whisper = WhisperBank.todayWhisper()
                        WidgetCenter.shared.reloadTimelines(ofKind: AppGroupStore.kind)
                    } label: {
                        Label("刷新今日碎念与小组件", systemImage: "arrow.clockwise")
                    }
                }

                Section("添加到主屏幕") {
                    Text("长按主屏幕空白处 → 点左上角 + → 搜索 DeskPet → 添加小组件。")
                        .font(.footnote)
                }
            }
            .navigationTitle("桌面宠物")
        }
    }

    private var batteryText: String {
        let percent = battery.batteryLevel < 0 ? 0 : Int((battery.batteryLevel * 100).rounded())
        return "电量 \(percent)%"
    }

    private var batterySymbol: String {
        let level = battery.batteryLevel
        if level < 0 || level < 0.25 { return "battery.0" }
        if level < 0.5 { return "battery.25" }
        if level < 0.75 { return "battery.50" }
        if level < 1.0 { return "battery.75" }
        return "battery.100"
    }
}
