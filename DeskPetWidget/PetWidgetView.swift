import SwiftUI
import WidgetKit

struct PetWidgetView: View {
    @Environment(\.widgetFamily) private var family
    var entry: PetEntry

    private var mood: PetMood {
        AppGroupStore.activeReaction() ?? entry.mood
    }

    private var whisper: String {
        if let reaction = AppGroupStore.activeReaction() {
            return WhisperBank.whisper(for: reaction, on: Date())
        }
        return entry.whisper
    }

    var body: some View {
        if family == .systemMedium {
            mediumLayout
        } else {
            smallLayout
        }
    }

    private var smallLayout: some View {
        VStack(spacing: 2) {
            Spacer(minLength: 2)
            PetCharacterView(mood: mood)
            Spacer(minLength: 2)
            reactionRow
        }
        .padding(.vertical, 6)
    }

    private var mediumLayout: some View {
        HStack(spacing: 12) {
            PetCharacterView(mood: mood)
            VStack(alignment: .leading, spacing: 10) {
                speechBubble
                reactionRow
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12)
    }

    private var speechBubble: some View {
        Text(whisper)
            .font(.caption)
            .lineLimit(3)
            .minimumScaleFactor(0.75)
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 10).fill(.regularMaterial))
    }

    private var reactionRow: some View {
        HStack(spacing: 8) {
            reactionButton(.happy, icon: "heart.fill")
            reactionButton(.surprised, icon: "exclamationmark")
            reactionButton(.sleepy, icon: "moon.zzz.fill")
        }
    }

    private func reactionButton(_ option: ReactionOption, icon: String) -> some View {
        Button(intent: PetReactIntent(reaction: option)) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(.primary)
                .frame(width: 30, height: 30)
                .background(Circle().fill(.thickMaterial))
        }
        .buttonStyle(.plain)
    }
}
