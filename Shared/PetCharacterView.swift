import SwiftUI
import UIKit

struct PetCharacterView: View {
    var mood: PetMood

    var body: some View {
        Group {
            if let image = UIImage(named: mood.frameName) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                placeholder
            }
        }
        .frame(width: 100, height: 112)
    }

    private var placeholder: some View {
        ZStack {
            WolfTailShape()
                .fill(hairColor)
                .frame(width: 38, height: 50)
                .offset(x: -30, y: 24)
            tankBody.offset(y: 34)
            head.offset(y: -4)
            accessory(for: mood).offset(x: 24, y: -38)
        }
        .frame(width: 100, height: 112)
    }

    private var head: some View {
        ZStack {
            Ellipse()
                .fill(skinColor)
                .frame(width: 62, height: 58)
            WolfHairShape()
                .fill(hairColor)
                .frame(width: 70, height: 56)
            sideHair
            face
            piercings
        }
    }

    private var sideHair: some View {
        ZStack {
            Capsule().fill(hairColor).frame(width: 7, height: 26).offset(x: -27, y: 8)
            Capsule().fill(hairColor).frame(width: 7, height: 20).offset(x: 27, y: 4)
        }
    }

    private var tankBody: some View {
        ZStack {
            TankTopShape().fill(hairColor).frame(width: 46, height: 30)
            Capsule().fill(silverColor).frame(width: 18, height: 1.4).rotationEffect(.degrees(40)).offset(x: 5, y: 6)
            Circle().fill(silverColor).frame(width: 3, height: 3).offset(x: 8, y: 9)
        }
    }

    private var face: some View {
        ZStack {
            eyes.offset(y: -8)
            mouth.offset(y: 12)
        }
    }

    @ViewBuilder
    private var eyes: some View {
        switch mood {
        case .reactHappy:
            HStack(spacing: 20) {
                BrowShape().stroke(eyeColor, style: StrokeStyle(lineWidth: 2.4, lineCap: .round)).frame(width: 13, height: 7)
                BrowShape().stroke(eyeColor, style: StrokeStyle(lineWidth: 2.4, lineCap: .round)).frame(width: 13, height: 7)
            }
        case .reactSurprised:
            HStack(spacing: 22) {
                Ellipse().fill(Color.white).frame(width: 12, height: 10).overlay(Circle().fill(eyeColor).frame(width: 5, height: 5).offset(y: 1))
                Ellipse().fill(Color.white).frame(width: 12, height: 10).overlay(Circle().fill(eyeColor).frame(width: 5, height: 5).offset(y: 1))
            }
        case .night, .reactSleepy:
            HStack(spacing: 22) {
                Capsule().fill(eyeColor).frame(width: 12, height: 2.4)
                Capsule().fill(eyeColor).frame(width: 12, height: 2.4)
            }
        default:
            HStack(spacing: 22) {
                halfLidEye
                halfLidEye
            }
        }
    }

    private var halfLidEye: some View {
        ZStack {
            Ellipse().fill(Color.white).frame(width: 12, height: 7)
            Circle().fill(eyeColor).frame(width: 4, height: 4).offset(y: 1.5)
            Capsule().fill(skinColor).frame(width: 14, height: 4.5).offset(y: -2.5)
        }
    }

    @ViewBuilder
    private var mouth: some View {
        switch mood {
        case .reactSurprised:
            Circle().stroke(eyeColor, lineWidth: 1.8).frame(width: 7, height: 7)
        case .reactHappy:
            SmileShape().stroke(eyeColor, style: StrokeStyle(lineWidth: 2, lineCap: .round)).frame(width: 11, height: 6)
        default:
            Capsule().fill(eyeColor).frame(width: 9, height: 1.8)
        }
    }

    private var piercings: some View {
        ZStack {
            Circle().stroke(silverColor, lineWidth: 1.4).frame(width: 5, height: 5).offset(x: 24, y: -12)
            Circle().stroke(silverColor, lineWidth: 1.2).frame(width: 4, height: 4).offset(x: -7, y: 14)
        }
    }

    private var iconName: String? {
        switch mood {
        case .morning: return "sun.max.fill"
        case .noon: return "sparkles"
        case .afternoon: return "cup.and.saucer.fill"
        case .evening: return "sunset.fill"
        case .night: return "moon.stars.fill"
        case .charging: return "bolt.fill"
        case .lowBattery: return "drop.fill"
        case .reactHappy: return "heart.fill"
        case .reactSurprised: return "exclamationmark"
        case .reactSleepy: return nil
        }
    }

    @ViewBuilder
    private func accessory(for mood: PetMood) -> some View {
        if let icon = iconName {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(silverColor)
        } else {
            Text("Zzz")
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(silverColor)
        }
    }

    private var skinColor: Color { Color(red: 0.93, green: 0.90, blue: 0.90) }
    private var hairColor: Color { Color(red: 0.10, green: 0.10, blue: 0.11) }
    private var silverColor: Color { Color(red: 0.78, green: 0.80, blue: 0.82) }
    private var eyeColor: Color { Color(red: 0.16, green: 0.16, blue: 0.18) }
}

private struct WolfHairShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX + 4, y: rect.minY + 10))
        path.addLine(to: CGPoint(x: rect.minX + 10, y: rect.minY + 4))
        let fractions: [CGFloat] = [0.16, 0.24, 0.34, 0.42, 0.52, 0.60, 0.70, 0.80, 0.90]
        for (index, fraction) in fractions.enumerated() {
            let x = rect.minX + rect.width * fraction
            let y = index.isMultiple(of: 2) ? rect.minY + 10 : rect.minY + 3
            path.addLine(to: CGPoint(x: x, y: y))
        }
        path.addLine(to: CGPoint(x: rect.maxX - 6, y: rect.minY + 14))
        path.addLine(to: CGPoint(x: rect.maxX - 2, y: rect.midY + 4))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

private struct WolfTailShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.30, y: rect.minY))
        path.addQuadCurve(to: CGPoint(x: rect.minX + rect.width * 0.78, y: rect.maxY), control: CGPoint(x: rect.minX + rect.width * 0.55, y: rect.midY))
        path.addQuadCurve(to: CGPoint(x: rect.minX + rect.width * 0.18, y: rect.minY + rect.height * 0.9), control: CGPoint(x: rect.minX + rect.width * 0.30, y: rect.midY))
        path.closeSubpath()
        return path
    }
}

private struct TankTopShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX - 20, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX + 20, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - 6, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX + 6, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

private struct SmileShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.midY), control: CGPoint(x: rect.midX, y: rect.maxY))
        return path
    }
}

private struct BrowShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.maxY), control: CGPoint(x: rect.midX, y: rect.minY))
        return path
    }
}
