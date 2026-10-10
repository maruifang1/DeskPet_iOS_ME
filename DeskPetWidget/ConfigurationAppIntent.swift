import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "桌宠设置"
    static var description = IntentDescription("配置主屏桌宠小组件")

    init() {}
}
