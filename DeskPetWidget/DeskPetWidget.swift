import SwiftUI
import WidgetKit

@main
struct DeskPetWidgetBundle: WidgetBundle {
    var body: some Widget {
        DeskPetWidget()
    }
}

struct DeskPetWidget: Widget {
    let kind = AppGroupStore.kind

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: PetTimelineProvider()) { entry in
            PetWidgetView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("桌面宠物")
        .description("住在主屏幕上的小桌宠")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemSmall) {
    DeskPetWidget()
} timeline: {
    PetEntry(date: Date(), mood: .morning, whisper: WhisperBank.whisper(for: .morning, on: Date()))
    PetEntry(date: Date().addingTimeInterval(3600), mood: .night, whisper: WhisperBank.whisper(for: .night, on: Date()))
}

#Preview(as: .systemMedium) {
    DeskPetWidget()
} timeline: {
    PetEntry(date: Date(), mood: .evening, whisper: WhisperBank.whisper(for: .evening, on: Date()))
}
