import Foundation
import SwiftUI

// MARK: - Enums

enum LiturgicalSeason: String, Codable, CaseIterable {
    case advent, christmas, afterEpiphany, septuagesima
    case lent, passiontide, holyWeek
    case easter, ascensiontide, afterPentecost

    var displayName: String {
        switch self {
        case .advent: "Advent"
        case .christmas: "Christmastide"
        case .afterEpiphany: "Time after Epiphany"
        case .septuagesima: "Septuagesima"
        case .lent: "Lent"
        case .passiontide: "Passiontide"
        case .holyWeek: "Holy Week"
        case .easter: "Eastertide"
        case .ascensiontide: "Ascensiontide"
        case .afterPentecost: "Time after Pentecost"
        }
    }

    var latinName: String {
        switch self {
        case .advent: "Tempus Adventus"
        case .christmas: "Tempus Nativitatis"
        case .afterEpiphany: "Tempus post Epiphaniam"
        case .septuagesima: "Tempus Septuagesimae"
        case .lent: "Tempus Quadragesimae"
        case .passiontide: "Tempus Passionis"
        case .holyWeek: "Hebdomada Sancta"
        case .easter: "Tempus Paschale"
        case .ascensiontide: "Tempus Ascensionis"
        case .afterPentecost: "Tempus post Pentecosten"
        }
    }
}

enum CelebrationRank: Int, Codable, Comparable {
    case classI = 1, classII = 2, classIII = 3, feriaPrivileged = 4, classIV = 5, feria = 6

    static func < (lhs: CelebrationRank, rhs: CelebrationRank) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    var displayName: String {
        switch self {
        case .classI: "I. Class"
        case .classII: "II. Class"
        case .classIII: "III. Class"
        case .classIV: "IV. Class"
        case .feriaPrivileged: "Privileged Feria"
        case .feria: "Feria"
        }
    }
}

enum CelebrationCategory: String, Codable {
    case feastOfLord, solemnity, feast, memorial, optionalMemorial
    case feria, vigil, withinOctave, octaveDay
    case rogationDay, emberDay, sunday
}

enum LiturgicalColor: String, Codable, CaseIterable {
    case white, red, green, violet, rose, black, gold

    var color: Color {
        switch self {
        case .white: Color(red: 0.95, green: 0.93, blue: 0.88)
        case .red: Color(red: 0.72, green: 0.11, blue: 0.11)
        case .green: Color(red: 0.18, green: 0.49, blue: 0.20)
        case .violet: Color(red: 0.40, green: 0.15, blue: 0.56)
        case .rose: Color(red: 0.85, green: 0.55, blue: 0.60)
        case .black: Color(red: 0.15, green: 0.15, blue: 0.15)
        case .gold: Color(red: 0.83, green: 0.69, blue: 0.22)
        }
    }

    var textColor: Color {
        switch self {
        case .white, .rose, .gold: .black
        default: .white
        }
    }

    var displayName: String { rawValue.capitalized }
}

// MARK: - Data Structures

struct Celebration: Identifiable, Equatable {
    let id: String
    let title: String          // Latin
    let titleVernacular: String // English
    let rank: CelebrationRank
    let category: CelebrationCategory
    let color: LiturgicalColor
    let precedence: UInt8

    static func == (lhs: Celebration, rhs: Celebration) -> Bool { lhs.id == rhs.id }
}

struct LiturgicalDay: Identifiable {
    var id: Date { date }
    let date: Date
    let season: LiturgicalSeason
    let week: UInt8
    let celebration: Celebration
    let commemorations: [Celebration]
    let color: LiturgicalColor
}

struct MoveableFeasts {
    let easter, septuagesima, ashWednesday, passionSunday, palmSunday: Date
    let holyThursday, goodFriday, holySaturday: Date
    let ascension, pentecost, corpusChristi, sacredHeart: Date
    let christTheKing, advent1: Date
    let emberDays: [Date]
    let rogationDays: [Date]
}
