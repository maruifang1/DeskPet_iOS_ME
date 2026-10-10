import Foundation
import WidgetKit

struct PetEntry: TimelineEntry {
    let date: Date
    let mood: PetMood
    let whisper: String
}
