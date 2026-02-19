import SwiftUI

struct CalendarMonthView: View {
    let engine = LiturgicalCalendarEngine.shared
    @State private var displayedYear: Int
    @State private var displayedMonth: Int
    @State private var selectedDay: LiturgicalDay?
    @State private var showDetail = false

    init() {
        let cal = Calendar(identifier: .gregorian)
        let now = Date()
        _displayedYear = State(initialValue: cal.component(.year, from: now))
        _displayedMonth = State(initialValue: cal.component(.month, from: now))
    }

    private var monthName: String {
        let df = DateFormatter()
        df.dateFormat = "MMMM yyyy"
        return df.string(from: makeDate(year: displayedYear, month: displayedMonth, day: 1))
    }

    private var days: [LiturgicalDay] {
        engine.daysInMonth(year: displayedYear, month: displayedMonth)
    }

    private var firstWeekday: Int {
        guard let first = days.first else { return 1 }
        return weekday(of: first.date)
    }

    private var todayComponents: DateComponents {
        Calendar(identifier: .gregorian).dateComponents([.year, .month, .day], from: Date())
    }

    private func isToday(_ date: Date) -> Bool {
        let tc = todayComponents
        return year(of: date) == tc.year && month(of: date) == tc.month && day(of: date) == tc.day
    }

    var body: some View {
        VStack(spacing: 0) {
            // Month navigation
            HStack {
                Button { prevMonth() } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3.weight(.semibold))
                        .foregroundColor(LiturgicalTheme.burgundy)
                }
                Spacer()
                VStack(spacing: 2) {
                    Text(monthName)
                        .font(.custom("Georgia-Bold", size: 20))
                        .foregroundColor(LiturgicalTheme.bodyText)
                }
                Spacer()
                Button { nextMonth() } label: {
                    Image(systemName: "chevron.right")
                        .font(.title3.weight(.semibold))
                        .foregroundColor(LiturgicalTheme.burgundy)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)

            // Weekday headers
            let headers = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 2), count: 7), spacing: 2) {
                ForEach(headers, id: \.self) { h in
                    Text(h)
                        .font(.custom("Georgia", size: 11))
                        .foregroundColor(LiturgicalTheme.subtitleText)
                        .frame(height: 24)
                }

                // Empty cells
                ForEach(0..<(firstWeekday - 1), id: \.self) { _ in
                    Color.clear.frame(height: 72)
                }

                // Day cells
                ForEach(days) { day in
                    Button {
                        selectedDay = day
                        showDetail = true
                    } label: {
                        dayCellView(day)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 6)

            Spacer()
        }
        .background(LiturgicalTheme.background)
        .sheet(isPresented: $showDetail) {
            if let day = selectedDay {
                DayDetailView(day: day)
            }
        }
    }

    @ViewBuilder
    private func dayCellView(_ day: LiturgicalDay) -> some View {
        let today = isToday(day.date)
        VStack(spacing: 1) {
            // Day number
            Text("\(Foundation.day(of: day.date))")
                .font(.custom("Georgia-Bold", size: 13))
                .foregroundColor(today ? .white : day.color.textColor)

            // Feast name (truncated)
            if day.celebration.category != .feria {
                Text(shortFeastName(day.celebration.titleVernacular))
                    .font(.custom("Georgia", size: 7))
                    .foregroundColor(today ? .white.opacity(0.85) : day.color.textColor.opacity(0.8))
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .frame(height: 20)
            } else {
                Spacer().frame(height: 20)
            }

            // Color dot
            Circle()
                .fill(today ? .white.opacity(0.7) : day.color.color)
                .frame(width: 5, height: 5)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 72)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(today ? LiturgicalTheme.burgundy : day.color.color.opacity(0.15))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(today ? LiturgicalTheme.gold : Color.clear, lineWidth: today ? 2 : 0)
        )
    }

    private func shortFeastName(_ name: String) -> String {
        // Abbreviate long names
        var s = name
        s = s.replacingOccurrences(of: "of Our Lord", with: "")
        s = s.replacingOccurrences(of: "of the BVM", with: "BVM")
        s = s.replacingOccurrences(of: ", Apostle and Evangelist", with: "")
        s = s.replacingOccurrences(of: ", Apostle", with: "")
        s = s.replacingOccurrences(of: ", Evangelist", with: "")
        s = s.replacingOccurrences(of: "Sunday", with: "Sun.")
        s = s.replacingOccurrences(of: "after Pentecost", with: "Pent.")
        return s.trimmingCharacters(in: .whitespaces)
    }

    private func prevMonth() {
        if displayedMonth == 1 {
            displayedMonth = 12; displayedYear -= 1
        } else { displayedMonth -= 1 }
    }

    private func nextMonth() {
        if displayedMonth == 12 {
            displayedMonth = 1; displayedYear += 1
        } else { displayedMonth += 1 }
    }
}
