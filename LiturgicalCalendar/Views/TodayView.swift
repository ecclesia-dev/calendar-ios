import SwiftUI

struct TodayView: View {
    let engine = LiturgicalCalendarEngine.shared
    @State private var today: LiturgicalDay?

    var body: some View {
        ScrollView {
            if let day = today {
                VStack(spacing: 0) {
                    // Hero banner with liturgical color
                    ZStack {
                        day.color.color
                            .ignoresSafeArea(edges: .top)

                        VStack(spacing: 16) {
                            // Cross ornament
                            Text(LiturgicalTheme.cross)
                                .font(.system(size: 28))
                                .foregroundColor(day.color.textColor.opacity(0.5))

                            Text(day.date.formatted(.dateTime.weekday(.wide)))
                                .font(.custom("Georgia", size: 13))
                                .textCase(.uppercase)
                                .tracking(4)
                                .foregroundColor(day.color.textColor.opacity(0.7))

                            Text(day.date.formatted(.dateTime.month(.wide).day().year()))
                                .font(.custom("Georgia", size: 17))
                                .foregroundColor(day.color.textColor.opacity(0.85))

                            // Gold divider
                            Rectangle()
                                .fill(day.color.textColor.opacity(0.25))
                                .frame(width: 80, height: 1)

                            Text(day.celebration.titleVernacular)
                                .font(.custom("Georgia-Bold", size: 26))
                                .multilineTextAlignment(.center)
                                .foregroundColor(day.color.textColor)
                                .padding(.horizontal, 24)

                            Text(day.celebration.title)
                                .font(.custom("Georgia-Italic", size: 15))
                                .multilineTextAlignment(.center)
                                .foregroundColor(day.color.textColor.opacity(0.7))
                                .padding(.horizontal, 24)

                            // Rank badge
                            Text(day.celebration.rank.displayName)
                                .font(.custom("Georgia", size: 12))
                                .tracking(1)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 5)
                                .background(
                                    Capsule()
                                        .fill(day.color.textColor.opacity(0.15))
                                )
                                .foregroundColor(day.color.textColor.opacity(0.8))
                        }
                        .padding(.vertical, 44)
                    }

                    // Info card
                    VStack(spacing: 0) {
                        VStack(spacing: 18) {
                            detailRow(icon: "paintpalette.fill", label: "Color", value: day.color.displayName, swatch: day.color.color)
                            detailRow(icon: "leaf.fill", label: "Season", value: day.season.displayName)
                            detailRow(icon: "book.fill", label: "Tempus", value: day.season.latinName)

                            // Readings if available
                            if let readings = ReadingsReference.forCelebration(day.celebration.id) {
                                Divider().overlay(LiturgicalTheme.divider)
                                VStack(alignment: .leading, spacing: 10) {
                                    sectionHeader("Readings")
                                    readingRow("Epistle", readings.epistle)
                                    readingRow("Gospel", readings.gospel)
                                    if let introit = readings.introit {
                                        readingRow("Introit", introit)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }

                            if !day.commemorations.isEmpty {
                                Divider().overlay(LiturgicalTheme.divider)
                                VStack(alignment: .leading, spacing: 10) {
                                    sectionHeader("Commemorations")
                                    ForEach(day.commemorations) { comm in
                                        HStack(spacing: 10) {
                                            RoundedRectangle(cornerRadius: 2)
                                                .fill(comm.color.color)
                                                .frame(width: 4, height: 36)
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text(comm.titleVernacular)
                                                    .font(.custom("Georgia", size: 15))
                                                    .foregroundColor(LiturgicalTheme.bodyText)
                                                Text(comm.title)
                                                    .font(.custom("Georgia-Italic", size: 12))
                                                    .foregroundColor(LiturgicalTheme.subtitleText)
                                            }
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(24)
                    }
                    .background(LiturgicalTheme.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
                    .padding(.horizontal, 16)
                    .padding(.top, -20)
                    .padding(.bottom, 24)
                }
            } else {
                ProgressView()
                    .tint(LiturgicalTheme.burgundy)
                    .padding(100)
            }
        }
        .background(LiturgicalTheme.background)
        .onAppear { today = engine.today() }
    }

    private func detailRow(icon: String, label: String, value: String, swatch: Color? = nil) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 13))
                .foregroundColor(LiturgicalTheme.gold)
                .frame(width: 20)
            Text(label)
                .font(.custom("Georgia", size: 12))
                .textCase(.uppercase)
                .tracking(1.5)
                .foregroundColor(LiturgicalTheme.subtitleText)
            Spacer()
            HStack(spacing: 6) {
                if let c = swatch {
                    Circle().fill(c)
                        .frame(width: 12, height: 12)
                        .overlay(Circle().stroke(Color.black.opacity(0.1), lineWidth: 0.5))
                }
                Text(value)
                    .font(.custom("Georgia", size: 15))
                    .foregroundColor(LiturgicalTheme.bodyText)
            }
        }
    }

    private func sectionHeader(_ text: String) -> some View {
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
}
