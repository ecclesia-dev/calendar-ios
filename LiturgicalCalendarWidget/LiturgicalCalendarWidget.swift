import WidgetKit
import SwiftUI

struct LiturgicalEntry: TimelineEntry {
    let date: Date
    let feastName: String
    let latinName: String
    let rank: String
    let color: LiturgicalColor
    let season: String
    let dayOfWeek: String
    let dayNumber: String
    let monthName: String
}

struct LiturgicalProvider: TimelineProvider {
    func placeholder(in context: Context) -> LiturgicalEntry {
        LiturgicalEntry(date: Date(), feastName: "Easter Sunday", latinName: "Dominica Resurrectionis",
                        rank: "I. Class", color: .white, season: "Eastertide",
                        dayOfWeek: "Sunday", dayNumber: "20", monthName: "April")
    }

    func getSnapshot(in context: Context, completion: @escaping (LiturgicalEntry) -> Void) {
        completion(makeEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<LiturgicalEntry>) -> Void) {
        let entry = makeEntry()
        let cal = Calendar(identifier: .gregorian)
        let tomorrow = cal.startOfDay(for: cal.date(byAdding: .day, value: 1, to: Date())!)
        completion(Timeline(entries: [entry], policy: .after(tomorrow)))
    }

    private func makeEntry() -> LiturgicalEntry {
        let engine = LiturgicalCalendarEngine.shared
        let now = Date()
        let cal = Calendar(identifier: .gregorian)
        let df = DateFormatter()

        if let day = engine.today() {
            df.dateFormat = "EEEE"
            let dow = df.string(from: now)
            df.dateFormat = "d"
            let dn = df.string(from: now)
            df.dateFormat = "MMMM"
            let mn = df.string(from: now)

            return LiturgicalEntry(
                date: now,
                feastName: day.celebration.titleVernacular,
                latinName: day.celebration.title,
                rank: day.celebration.rank.displayName,
                color: day.color,
                season: day.season.displayName,
                dayOfWeek: dow, dayNumber: dn, monthName: mn
            )
        }
        return LiturgicalEntry(date: now, feastName: "—", latinName: "", rank: "", color: .white,
                               season: "", dayOfWeek: "", dayNumber: "", monthName: "")
    }
}

struct LiturgicalWidgetEntryView: View {
    var entry: LiturgicalEntry
    @Environment(\.widgetFamily) var family

    var body: some View {
        ZStack {
            entry.color.color

            VStack(spacing: 6) {
                // Cross
                Text("✠")
                    .font(.system(size: family == .systemSmall ? 14 : 16))
                    .foregroundColor(entry.color.textColor.opacity(0.4))

                if family != .systemSmall {
                    Text("\(entry.dayOfWeek) · \(entry.monthName) \(entry.dayNumber)")
                        .font(.custom("Georgia", size: 10))
                        .tracking(1)
                        .foregroundColor(entry.color.textColor.opacity(0.55))
                }

                Text(entry.feastName)
                    .font(.custom("Georgia-Bold", size: family == .systemSmall ? 14 : 18))
                    .multilineTextAlignment(.center)
                    .foregroundColor(entry.color.textColor)
                    .lineLimit(3)
                    .minimumScaleFactor(0.65)

                if family != .systemSmall {
                    Text(entry.latinName)
                        .font(.custom("Georgia-Italic", size: 11))
                        .foregroundColor(entry.color.textColor.opacity(0.6))
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                }

                // Rank + Season
                HStack(spacing: 4) {
                    Text(entry.rank)
                    if family != .systemSmall {
                        Text("·")
                        Text(entry.season)
                    }
                }
                .font(.custom("Georgia", size: 9))
                .foregroundColor(entry.color.textColor.opacity(0.45))
            }
            .padding(family == .systemSmall ? 10 : 14)
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
        .description("Today's feast, rank, and liturgical color from the 1962 Roman Calendar.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
