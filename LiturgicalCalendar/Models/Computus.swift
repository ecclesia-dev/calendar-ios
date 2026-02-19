import Foundation

// MARK: - Date Helpers

private let gregorianCalendar: Calendar = {
    var cal = Calendar(identifier: .gregorian)
    cal.timeZone = TimeZone(identifier: "UTC")!
    return cal
}()

func makeDate(year: Int, month: Int, day: Int) -> Date {
    gregorianCalendar.date(from: DateComponents(year: year, month: month, day: day))!
}

func addDays(_ date: Date, _ days: Int) -> Date {
    gregorianCalendar.date(byAdding: .day, value: days, to: date)!
}

func daysBetween(_ from: Date, _ to: Date) -> Int {
    gregorianCalendar.dateComponents([.day], from: from, to: to).day!
}

func weekday(of date: Date) -> Int {
    gregorianCalendar.component(.weekday, from: date) // 1=Sun, 7=Sat
}

func month(of date: Date) -> Int { gregorianCalendar.component(.month, from: date) }
func day(of date: Date) -> Int { gregorianCalendar.component(.day, from: date) }
func year(of date: Date) -> Int { gregorianCalendar.component(.year, from: date) }

func isSunday(_ date: Date) -> Bool { weekday(of: date) == 1 }

func weekdayName(_ date: Date) -> String {
    let names = ["", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    return names[weekday(of: date)]
}

// MARK: - Computus (Anonymous Gregorian Algorithm)

func easter(year: Int) -> Date {
    let a = year % 19
    let b = year / 100
    let c = year % 100
    let d = b / 4
    let e = b % 4
    let f = (b + 8) / 25
    let g = (b - f + 1) / 3
    let h = (19 * a + b - d - g + 15) % 30
    let i = c / 4
    let k = c % 4
    let l = (32 + 2 * e + 2 * i - h - k) % 7
    let m = (a + 11 * h + 22 * l) / 451
    let month = (h + l - 7 * m + 114) / 31
    let day = (h + l - 7 * m + 114) % 31 + 1
    return makeDate(year: year, month: month, day: day)
}

// MARK: - Moveable Feasts

func computeMoveableFeasts(year: Int) -> MoveableFeasts {
    let e = easter(year: year)
    let septuagesima = addDays(e, -63)
    let ashWednesday = addDays(e, -46)
    let passionSunday = addDays(e, -14)
    let palmSunday = addDays(e, -7)
    let holyThursday = addDays(e, -3)
    let goodFriday = addDays(e, -2)
    let holySaturday = addDays(e, -1)
    let ascension = addDays(e, 39)
    let pentecost = addDays(e, 49)
    let corpusChristi = addDays(e, 60)
    let sacredHeart = addDays(corpusChristi, 8)

    // Christ the King: last Sunday of October
    let oct31 = makeDate(year: year, month: 10, day: 31)
    let daysFromSun = (weekday(of: oct31) - 1 + 7) % 7  // weekday 1=Sun → 0
    let christTheKing = addDays(oct31, -daysFromSun)

    // Advent 1: Sunday nearest Nov 30
    let nov30 = makeDate(year: year, month: 11, day: 30)
    let dfs = (weekday(of: nov30) - 1 + 7) % 7
    let advent1 = dfs <= 3 ? addDays(nov30, -dfs) : addDays(nov30, 7 - dfs)

    // Ember days
    let firstSundayOfLent = addDays(ashWednesday, 4)
    let lentEmber = [addDays(firstSundayOfLent, 3), addDays(firstSundayOfLent, 5), addDays(firstSundayOfLent, 6)]
    let pentEmber = [addDays(pentecost, 3), addDays(pentecost, 5), addDays(pentecost, 6)]

    let sept1 = makeDate(year: year, month: 9, day: 1)
    let daysToSun = (8 - weekday(of: sept1)) % 7
    let firstSundaySept = addDays(sept1, daysToSun)
    let thirdSundaySept = addDays(firstSundaySept, 14)
    let septEmber = [addDays(thirdSundaySept, 3), addDays(thirdSundaySept, 5), addDays(thirdSundaySept, 6)]

    let advent3 = addDays(advent1, 14)
    let adventEmber = [addDays(advent3, 3), addDays(advent3, 5), addDays(advent3, 6)]

    let emberDays = lentEmber + pentEmber + septEmber + adventEmber
    let rogationDays = [addDays(ascension, -3), addDays(ascension, -2), addDays(ascension, -1)]

    return MoveableFeasts(
        easter: e, septuagesima: septuagesima, ashWednesday: ashWednesday,
        passionSunday: passionSunday, palmSunday: palmSunday,
        holyThursday: holyThursday, goodFriday: goodFriday, holySaturday: holySaturday,
        ascension: ascension, pentecost: pentecost, corpusChristi: corpusChristi,
        sacredHeart: sacredHeart, christTheKing: christTheKing, advent1: advent1,
        emberDays: emberDays, rogationDays: rogationDays
    )
}
