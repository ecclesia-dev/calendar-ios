import WidgetKit
import SwiftUI

struct LiturgicalEntry: TimelineEntry {
    let date: Date
    let feastName: String
    let latinName: String
    let rank: String
    let color: LiturgicalColor
    let season: String
}

struct LiturgicalProvider: TimelineProvider {
    func placeholder(in context: Context) -> LiturgicalEntry {
        LiturgicalEntry(date: Date(), feastName: "Easter Sunday", latinName: "Dominica Resurrectionis", rank: "I. Class", color: .white, season: "Eastertide")
    }

    func getSnapshot(in context: Context, completion: @escaping (LiturgicalEntry) -> Void) {
        completion(makeEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<LiturgicalEntry>) -> Void) {
        let entry = makeEntry()
        // Update at midnight
        let cal = Calendar(identifier: .gregorian)
        let tomorrow = cal.startOfDay(for: cal.date(byAdding: .day, value: 1, to: Date())!)
        completion(Timeline(entries: [entry], policy: .after(tomorrow)))
    }

    private func makeEntry() -> LiturgicalEntry {
        let engine = LiturgicalCalendarEngine.shared
        if let day = engine.today() {
            return LiturgicalEntry(
                date: Date(),
                feastName: day.celebration.titleVernacular,
                latinName: day.celebration.title,
                rank: day.celebration.rank.displayName,
                color: day.color,
                season: day.season.displayName
            )
        }
        return LiturgicalEntry(date: Date(), feastName: "—", latinName: "", rank: "", color: .white, season: "")
    }
}

struct LiturgicalWidgetEntryView: View {
    var entry: LiturgicalEntry
    @Environment(\.widgetFamily) var family

    var body: some View {
        ZStack {
            entry.color.color
            VStack(spacing: 4) {
                if family != .systemSmall {
                    Text(entry.season.uppercased())
                        .font(.custom("Georgia", size: 9))
                        .tracking(2)
                        .foregroundColor(entry.color.textColor.opacity(0.6))
                }
                Text(entry.feastName)
                    .font(.custom("Georgia-Bold", size: family == .systemSmall ? 14 : 17))
                    .multilineTextAlignment(.center)
                    .foregroundColor(entry.color.textColor)
                    .lineLimit(3)
                    .minimumScaleFactor(0.7)

                if family != .systemSmall {
                    Text(entry.latinName)
                        .font(.custom("Georgia-Italic", size: 11))
                        .foregroundColor(entry.color.textColor.opacity(0.65))
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                }
                Text(entry.rank)
                    .font(.custom("Georgia", size: 10))
                    .foregroundColor(entry.color.textColor.opacity(0.5))
            }
            .padding(12)
        }
    }
}

struct LiturgicalCalendarWidget: Widget {
    let kind: String = "LiturgicalCalendarWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: LiturgicalProvider()) { entry in
            LiturgicalWidgetEntryView(entry: entry)
                .containerBackground(entry.color.color, for: .widget)
        }
        .configurationDisplayName("Liturgical Day")
        .description("Today's feast and liturgical color.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
