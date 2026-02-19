import SwiftUI

struct DayDetailView: View {
    let day: LiturgicalDay
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Color banner
                    ZStack {
                        day.color.color

                        VStack(spacing: 14) {
                            Text(LiturgicalTheme.cross)
                                .font(.system(size: 24))
                                .foregroundColor(day.color.textColor.opacity(0.4))

                            Text(day.date.formatted(.dateTime.weekday(.wide).month(.wide).day().year()))
                                .font(.custom("Georgia", size: 14))
                                .foregroundColor(day.color.textColor.opacity(0.75))

                            Text(day.celebration.titleVernacular)
                                .font(.custom("Georgia-Bold", size: 24))
                                .multilineTextAlignment(.center)
                                .foregroundColor(day.color.textColor)
                                .padding(.horizontal)

                            Text(day.celebration.title)
                                .font(.custom("Georgia-Italic", size: 14))
                                .foregroundColor(day.color.textColor.opacity(0.65))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)

                            Text(day.celebration.rank.displayName)
                                .font(.custom("Georgia", size: 11))
                                .tracking(1)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(Capsule().fill(day.color.textColor.opacity(0.12)))
                                .foregroundColor(day.color.textColor.opacity(0.75))
                        }
                        .padding(.vertical, 36)
                    }

                    // Details
                    VStack(spacing: 16) {
                        infoRow("Color", day.color.displayName, swatch: day.color.color)
                        infoRow("Season", day.season.displayName)
                        infoRow("Latin Season", day.season.latinName)
                        infoRow("Week", "\(day.week)")
                        infoRow("Category", formatCategory(day.celebration.category))

                        // Readings
                        if let readings = ReadingsReference.forCelebration(day.celebration.id) {
                            Divider().overlay(LiturgicalTheme.divider)
                            VStack(alignment: .leading, spacing: 10) {
                                sectionLabel("Propers")
                                readingRow("Epistle", readings.epistle)
                                readingRow("Gospel", readings.gospel)
                                if let introit = readings.introit {
                                    readingRow("Introit", introit)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        // Commemorations
                        if !day.commemorations.isEmpty {
                            Divider().overlay(LiturgicalTheme.divider)
                            VStack(alignment: .leading, spacing: 10) {
                                sectionLabel("Commemorations")

                                ForEach(day.commemorations) { c in
                                    HStack(alignment: .top, spacing: 10) {
                                        RoundedRectangle(cornerRadius: 2)
                                            .fill(c.color.color)
                                            .frame(width: 4)
                                        VStack(alignment: .leading, spacing: 3) {
                                            Text(c.titleVernacular)
                                                .font(.custom("Georgia", size: 15))
                                                .foregroundColor(LiturgicalTheme.bodyText)
                                            Text(c.title)
                                                .font(.custom("Georgia-Italic", size: 12))
                                                .foregroundColor(LiturgicalTheme.subtitleText)
                                            Text(c.rank.displayName)
                                                .font(.custom("Georgia", size: 11))
                                                .foregroundColor(LiturgicalTheme.subtitleText.opacity(0.7))
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        // Special notes
                        if let note = specialNote(for: day) {
                            Divider().overlay(LiturgicalTheme.divider)
                            VStack(alignment: .leading, spacing: 6) {
                                sectionLabel("Note")
                                Text(note)
                                    .font(.custom("Georgia-Italic", size: 14))
                                    .foregroundColor(LiturgicalTheme.bodyText)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(24)
                    .background(LiturgicalTheme.cardBackground)
                }
            }
            .background(LiturgicalTheme.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .font(.custom("Georgia", size: 16))
                        .foregroundColor(LiturgicalTheme.burgundy)
                }
            }
        }
    }

    private func infoRow(_ label: String, _ value: String, swatch: Color? = nil) -> some View {
        HStack {
            Text(label)
                .font(.custom("Georgia", size: 12))
                .textCase(.uppercase)
                .tracking(1.5)
                .foregroundColor(LiturgicalTheme.subtitleText)
            Spacer()
            HStack(spacing: 6) {
                if let c = swatch {
                    Circle().fill(c).frame(width: 10, height: 10)
                        .overlay(Circle().stroke(Color.black.opacity(0.1), lineWidth: 0.5))
                }
                Text(value)
                    .font(.custom("Georgia", size: 15))
                    .foregroundColor(LiturgicalTheme.bodyText)
            }
        }
    }

    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.custom("Georgia-Bold", size: 12))
            .textCase(.uppercase)
            .tracking(2)
            .foregroundColor(LiturgicalTheme.burgundy)
    }

    private func readingRow(_ label: String, _ ref: String) -> some View {
        HStack {
            Text(label)
                .font(.custom("Georgia", size: 13))
                .foregroundColor(LiturgicalTheme.subtitleText)
                .frame(width: 60, alignment: .leading)
            Text(ref)
                .font(.custom("Georgia", size: 14))
                .foregroundColor(LiturgicalTheme.bodyText)
        }
    }

    private func formatCategory(_ cat: CelebrationCategory) -> String {
        cat.rawValue
            .replacingOccurrences(of: "([A-Z])", with: " $1", options: .regularExpression)
            .capitalized
            .trimmingCharacters(in: .whitespaces)
    }

    private func specialNote(for day: LiturgicalDay) -> String? {
        switch day.celebration.id {
        case "ash-wednesday": return "Blessing and imposition of ashes. Fast and abstinence."
        case "good-friday": return "Solemn Liturgy of the Passion. Fast and abstinence. No Mass celebrated."
        case "holy-saturday": return "The Easter Vigil. No Mass before the Vigil."
        case "palm-sunday": return "Blessing of palms and procession before the Mass."
        case "holy-thursday": return "Mass of the Lord's Supper. Stripping of the altars. Watching at the Altar of Repose."
        case "corpus-christi": return "Procession of the Blessed Sacrament."
        case "all-souls": return "Three Masses may be offered by each priest. The faithful may gain a plenary indulgence for the souls in Purgatory."
        default:
            if day.celebration.category == .emberDay {
                return "Ember Day. Fast and partial abstinence. Special ordination prayers."
            }
            if day.celebration.category == .rogationDay {
                return "Rogation Day. Litany of the Saints and procession for God's blessings on the harvest."
            }
            if day.celebration.id.contains("sunday-advent-3") {
                return "Gaudete Sunday. Rose vestments may be used. The third candle of the Advent wreath is lit."
            }
            if day.celebration.id.contains("sunday-lent-4") {
                return "Laetare Sunday. Rose vestments may be used. A brief respite in the Lenten fast."
            }
            return nil
        }
    }
}
