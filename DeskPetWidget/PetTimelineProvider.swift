import WidgetKit

struct PetTimelineProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> PetEntry {
        entry(for: Date())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> PetEntry {
        entry(for: Date())
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<PetEntry> {
        let now = Date()
        let calendar = Calendar.current
        let entries = (0..<24).compactMap { hourOffset in
            guard let date = calendar.date(byAdding: .hour, value: hourOffset, to: now) else {
                return nil
            }
            return entry(for: date)
        }
        return Timeline(entries: entries, policy: .atEnd)
    }

    private func entry(for date: Date) -> PetEntry {
        let power = ProcessInfo.processInfo.powerState
        let mood = MoodEngine.mood(
            at: date,
            isCharging: power.isCharging,
            batteryLevel: power.batteryLevel
        )
        return PetEntry(
            date: date,
            mood: mood,
            whisper: WhisperBank.whisper(for: mood, on: date)
        )
    }
}
