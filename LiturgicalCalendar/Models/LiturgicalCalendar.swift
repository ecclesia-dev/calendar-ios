import Foundation

class LiturgicalCalendarEngine {
    private var cache: [Int: [Date: LiturgicalDay]] = [:]

    static let shared = LiturgicalCalendarEngine()

    func calendar(for year: Int) -> [Date: LiturgicalDay] {
        if let cached = cache[year] { return cached }
        let days = buildCalendar(year: year)
        cache[year] = days
        return days
    }

    func day(for date: Date) -> LiturgicalDay? {
        let y = year(of: date)
        let cal = calendar(for: y)
        // Normalize to midnight UTC
        let normalized = makeDate(year: y, month: month(of: date), day: Foundation.day(of: date))
        return cal[normalized]
    }

    func today() -> LiturgicalDay? {
        let now = Date()
        let cal = Calendar(identifier: .gregorian)
        let comps = cal.dateComponents([.year, .month, .day], from: now)
        let normalized = makeDate(year: comps.year!, month: comps.month!, day: comps.day!)
        return day(for: normalized)
    }

    func daysInMonth(year: Int, month: Int) -> [LiturgicalDay] {
        let cal = calendar(for: year)
        return cal.values
            .filter { Foundation.month(of: $0.date) == month }
            .sorted { $0.date < $1.date }
    }

    func allSanctoralFeasts() -> [Celebration] {
        majorFeasts().map(\.celebration).sorted { $0.precedence < $1.precedence || ($0.precedence == $1.precedence && $0.rank < $1.rank) }
    }

    private func buildCalendar(year: Int) -> [Date: LiturgicalDay] {
        let temporal = buildTemporalCycle(year: year)
        let sanctoral = buildSanctoralCycle(year: year)
        var days: [Date: LiturgicalDay] = [:]

        for (date, entry, special) in temporal {
            let temporalCeleb: Celebration
            if let s = special {
                temporalCeleb = s
            } else if isSunday(date) {
                temporalCeleb = makeSunday(season: entry.season, week: entry.week)
            } else {
                temporalCeleb = makeFeria(season: entry.season, week: entry.week, date: date)
            }

            let sanctoralCelebs = sanctoral[date] ?? []
            let (winner, commemorations) = resolvePrecedence(temporal: temporalCeleb, sanctoral: sanctoralCelebs)

            days[date] = LiturgicalDay(
                date: date, season: entry.season, week: entry.week,
                celebration: winner, commemorations: commemorations, color: winner.color
            )
        }

        return days
    }
}
