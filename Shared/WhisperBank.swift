import Foundation

enum WhisperBank {
    static let lines: [PetMood: [String]] = [
        .morning: [
            "早呀，新的一天也要好好吃早饭哦",
            "太阳都出来了，该起床啦",
            "今天也要元气满满呀",
        ],
        .noon: [
            "到点吃饭啦，别饿着肚子",
            "中午了，起来活动活动吧",
            "午休一下，下午才有精神",
        ],
        .afternoon: [
            "下午也要加油哦",
            "喝口水，休息一下眼睛",
            "累了就歇一会儿吧",
        ],
        .evening: [
            "晚上好呀，今天辛苦啦",
            "天黑了，记得早点休息",
            "晚饭吃了吗？",
        ],
        .night: [
            "夜深了，快睡吧",
            "再不睡觉明天会困的",
            "晚安，做个好梦",
        ],
        .charging: [
            "在充电呢，感觉充满能量",
            "电量补满中，一会就回来",
            "谢谢帮我充电呀",
        ],
        .lowBattery: [
            "电量有点低了，记得充电哦",
            "我快没电了，快充一下",
            "电池告急，先充会儿电吧",
        ],
        .reactHappy: [
            "嘿嘿，被你摸得好开心",
            "最喜欢你啦",
            "今天也很喜欢你",
        ],
        .reactSurprised: [
            "哇，吓我一跳！",
            "诶？怎么啦？",
            "突然摸我，吓了一跳呢",
        ],
        .reactSleepy: [
            "哈欠……有点困了",
            "被你摸得好舒服，想睡了",
            "Zzz……再让我睡会儿",
        ],
    ]

    static func whisper(
        for mood: PetMood,
        on date: Date,
        calendar: Calendar = .current
    ) -> String {
        let pool = lines[mood] ?? lines[.morning] ?? ["……"]
        let day = calendar.ordinality(of: .day, in: .year, for: date) ?? 1
        return pool[(day - 1) % pool.count]
    }

    static func todayWhisper() -> String {
        whisper(for: MoodEngine.currentMood(), on: Date())
    }
}
