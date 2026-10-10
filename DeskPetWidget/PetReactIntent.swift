import AppIntents
import WidgetKit

enum ReactionOption: String, AppEnum {
    case happy, surprised, sleepy

    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        TypeDisplayRepresentation(name: "反应")
    }

    static var caseDisplayRepresentations: [ReactionOption: DisplayRepresentation] {
        [
            .happy: "开心",
            .surprised: "惊讶",
            .sleepy: "困了",
        ]
    }

    var mood: PetMood {
        switch self {
        case .happy: return .reactHappy
        case .surprised: return .reactSurprised
        case .sleepy: return .reactSleepy
        }
    }
}

struct PetReactIntent: AppIntent {
    static var title: LocalizedStringResource = "摸一下桌宠"
    static var description = IntentDescription("让桌宠做出反应")
    static var isDiscoverable: Bool { false }

    @Parameter(title: "反应类型", default: .happy)
    var reaction: ReactionOption

    init() {}

    init(reaction: ReactionOption) {
        self.reaction = reaction
    }

    func perform() async throws -> some IntentResult {
        AppGroupStore.recordReaction(reaction.mood)
        WidgetCenter.shared.reloadTimelines(ofKind: AppGroupStore.kind)
        return .result()
    }
}
