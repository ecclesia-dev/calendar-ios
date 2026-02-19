import Foundation

struct TemporalEntry {
    let season: LiturgicalSeason
    let week: UInt8
}

func buildTemporalCycle(year: Int) -> [(Date, TemporalEntry, Celebration?)] {
    let mf = computeMoveableFeasts(year: year)
    let jan1 = makeDate(year: year, month: 1, day: 1)
    let dec31 = makeDate(year: year, month: 12, day: 31)
    let epiphany = makeDate(year: year, month: 1, day: 6)
    let christmas = makeDate(year: year, month: 12, day: 25)

    var results: [(Date, TemporalEntry, Celebration?)] = []
    var date = jan1
    while date <= dec31 {
        let entry: TemporalEntry
        if date < epiphany {
            entry = TemporalEntry(season: .christmas, week: 1)
        } else if date >= epiphany && date < mf.septuagesima {
            let w = UInt8(daysBetween(epiphany, date) / 7) + 1
            entry = TemporalEntry(season: .afterEpiphany, week: w)
        } else if date >= mf.septuagesima && date < mf.ashWednesday {
            let w = UInt8(daysBetween(mf.septuagesima, date) / 7) + 1
            entry = TemporalEntry(season: .septuagesima, week: w)
        } else if date >= mf.ashWednesday && date < mf.passionSunday {
            let firstSunLent = addDays(mf.ashWednesday, 4)
            if date < firstSunLent {
                entry = TemporalEntry(season: .lent, week: 0)
            } else {
                let w = UInt8(daysBetween(firstSunLent, date) / 7) + 1
                entry = TemporalEntry(season: .lent, week: w)
            }
        } else if date >= mf.passionSunday && date < mf.palmSunday {
            entry = TemporalEntry(season: .passiontide, week: 1)
        } else if date >= mf.palmSunday && date < mf.easter {
            entry = TemporalEntry(season: .holyWeek, week: 1)
        } else if date >= mf.easter && date < mf.ascension {
            let w = UInt8(daysBetween(mf.easter, date) / 7) + 1
            entry = TemporalEntry(season: .easter, week: w)
        } else if date >= mf.ascension && date <= mf.pentecost {
            entry = TemporalEntry(season: .ascensiontide, week: 1)
        } else if date > mf.pentecost && date < mf.advent1 {
            let w = UInt8(daysBetween(mf.pentecost, date) / 7) + 1
            entry = TemporalEntry(season: .afterPentecost, week: w)
        } else if date >= mf.advent1 && date < christmas {
            let w = UInt8(daysBetween(mf.advent1, date) / 7) + 1
            entry = TemporalEntry(season: .advent, week: w)
        } else {
            entry = TemporalEntry(season: .christmas, week: 1)
        }

        let special = classifySpecial(date: date, mf: mf)
        results.append((date, entry, special))
        date = addDays(date, 1)
    }
    return results
}

// MARK: - Special Temporal Celebrations

private func classifySpecial(date: Date, mf: MoveableFeasts) -> Celebration? {
    if date == mf.easter {
        return Celebration(id: "easter-sunday", title: "Dominica Resurrectionis", titleVernacular: "Easter Sunday", rank: .classI, category: .solemnity, color: .white, precedence: 1)
    }
    // Easter Octave
    let daysAfterEaster = daysBetween(mf.easter, date)
    if daysAfterEaster > 0 && daysAfterEaster < 7 {
        return Celebration(id: "easter-octave-\(daysAfterEaster)", title: "Infra Octavam Paschae", titleVernacular: "\(weekdayName(date)) within the Octave of Easter", rank: .classI, category: .withinOctave, color: .white, precedence: 1)
    }
    // Low Sunday
    if daysAfterEaster == 7 {
        return Celebration(id: "low-sunday", title: "Dominica in Albis", titleVernacular: "Low Sunday (Octave Day of Easter)", rank: .classI, category: .octaveDay, color: .white, precedence: 1)
    }
    if date == mf.ashWednesday {
        return Celebration(id: "ash-wednesday", title: "Feria IV Cinerum", titleVernacular: "Ash Wednesday", rank: .classI, category: .feria, color: .violet, precedence: 3)
    }
    if date == mf.palmSunday {
        return Celebration(id: "palm-sunday", title: "Dominica in Palmis", titleVernacular: "Palm Sunday", rank: .classI, category: .sunday, color: .violet, precedence: 2)
    }
    if date == mf.holyThursday {
        return Celebration(id: "holy-thursday", title: "Feria V in Cena Domini", titleVernacular: "Holy Thursday", rank: .classI, category: .solemnity, color: .white, precedence: 1)
    }
    if date == mf.goodFriday {
        return Celebration(id: "good-friday", title: "Feria VI in Parasceve", titleVernacular: "Good Friday", rank: .classI, category: .solemnity, color: .black, precedence: 1)
    }
    if date == mf.holySaturday {
        return Celebration(id: "holy-saturday", title: "Sabbato Sancto", titleVernacular: "Holy Saturday", rank: .classI, category: .solemnity, color: .violet, precedence: 1)
    }
    if date == mf.ascension {
        return Celebration(id: "ascension", title: "In Ascensione Domini", titleVernacular: "The Ascension of Our Lord", rank: .classI, category: .feastOfLord, color: .white, precedence: 1)
    }
    if date == mf.pentecost {
        return Celebration(id: "pentecost", title: "Dominica Pentecostes", titleVernacular: "Pentecost Sunday", rank: .classI, category: .solemnity, color: .red, precedence: 1)
    }
    // Pentecost Octave
    let daysAfterPent = daysBetween(mf.pentecost, date)
    if daysAfterPent > 0 && daysAfterPent < 7 {
        return Celebration(id: "pentecost-octave-\(daysAfterPent)", title: "Infra Octavam Pentecostes", titleVernacular: "\(weekdayName(date)) within the Octave of Pentecost", rank: .classI, category: .withinOctave, color: .red, precedence: 1)
    }
    if date == mf.corpusChristi {
        return Celebration(id: "corpus-christi", title: "Ss.mi Corporis Christi", titleVernacular: "Corpus Christi", rank: .classI, category: .feastOfLord, color: .white, precedence: 1)
    }
    if date == mf.sacredHeart {
        return Celebration(id: "sacred-heart", title: "Ss.mi Cordis Jesu", titleVernacular: "The Most Sacred Heart of Jesus", rank: .classI, category: .feastOfLord, color: .white, precedence: 4)
    }
    if date == mf.christTheKing {
        return Celebration(id: "christ-the-king", title: "D.N. Jesu Christi Regis", titleVernacular: "Our Lord Jesus Christ the King", rank: .classI, category: .feastOfLord, color: .white, precedence: 4)
    }
    if mf.emberDays.contains(date) {
        return Celebration(id: "ember-\(month(of: date))-\(day(of: date))", title: "Feria Quatuor Temporum", titleVernacular: "Ember \(weekdayName(date))", rank: .feriaPrivileged, category: .emberDay, color: .violet, precedence: 8)
    }
    if mf.rogationDays.contains(date) {
        return Celebration(id: "rogation-\(month(of: date))-\(day(of: date))", title: "Feria Rogationum", titleVernacular: "Rogation \(weekdayName(date))", rank: .classIV, category: .rogationDay, color: .violet, precedence: 11)
    }
    // Septuagesima Sundays
    if date == mf.septuagesima {
        return makeSunday(season: .septuagesima, week: 1)
    }
    if date == addDays(mf.septuagesima, 7) {
        return makeSunday(season: .septuagesima, week: 2)
    }
    if date == addDays(mf.septuagesima, 14) {
        return makeSunday(season: .septuagesima, week: 3)
    }
    if date == mf.passionSunday {
        return makeSunday(season: .passiontide, week: 1)
    }
    // Last Sunday after Pentecost
    if isSunday(date) && date > addDays(mf.pentecost, 7) && date < mf.advent1 && addDays(date, 7) >= mf.advent1 {
        return Celebration(id: "last-sunday-after-pentecost", title: "Dominica Ultima post Pentecosten", titleVernacular: "Last Sunday after Pentecost", rank: .classI, category: .sunday, color: .green, precedence: 2)
    }
    return nil
}

// MARK: - Sunday/Feria builders

func makeSunday(season: LiturgicalSeason, week: UInt8) -> Celebration {
    let (color, rank, prec) = sundayAttributes(season: season, week: week)
    let title = "\(ordinal(week)) Sunday of \(season.displayName)"
    return Celebration(id: "sunday-\(season.rawValue)-\(week)", title: title, titleVernacular: title, rank: rank, category: .sunday, color: color, precedence: prec)
}

func makeFeria(season: LiturgicalSeason, week: UInt8, date: Date) -> Celebration {
    let (color, rank, prec): (LiturgicalColor, CelebrationRank, UInt8) = {
        switch season {
        case .advent: (.violet, .feriaPrivileged, 8)
        case .lent, .passiontide: (.violet, .feriaPrivileged, 8)
        case .holyWeek: (.violet, .classI, 3)
        case .christmas, .afterEpiphany: (.white, .feria, 11)
        case .septuagesima: (.violet, .feria, 11)
        case .easter, .ascensiontide: (.white, .feria, 11)
        case .afterPentecost: (.green, .feria, 11)
        }
    }()
    let dayName = weekdayName(date)
    let title = "Feria \(dayName) of \(season.displayName) Week \(week)"
    return Celebration(id: "feria-\(season.rawValue)-\(week)-\(dayName.lowercased())", title: title, titleVernacular: title, rank: rank, category: .feria, color: color, precedence: prec)
}

private func sundayAttributes(season: LiturgicalSeason, week: UInt8) -> (LiturgicalColor, CelebrationRank, UInt8) {
    switch season {
    case .advent:
        if week == 1 { return (.violet, .classI, 2) }
        if week == 3 { return (.rose, .classI, 6) } // Gaudete
        return (.violet, .classI, 6)
    case .christmas, .afterEpiphany: return (.white, .classII, 6)
    case .septuagesima: return (.violet, .classII, 6)
    case .lent:
        if week == 1 { return (.violet, .classI, 2) }
        if week == 4 { return (.rose, .classI, 6) } // Laetare
        return (.violet, .classI, 6)
    case .passiontide: return (.violet, .classI, 2)
    case .holyWeek: return (.violet, .classI, 2)
    case .easter:
        if week == 1 { return (.white, .classI, 1) }
        return (.white, .classII, 6)
    case .ascensiontide: return (.white, .classII, 6)
    case .afterPentecost: return (.green, .classII, 6)
    }
}

private func ordinal(_ n: UInt8) -> String {
    switch n {
    case 1: "1st"; case 2: "2nd"; case 3: "3rd"
    default: "\(n)th"
    }
}
