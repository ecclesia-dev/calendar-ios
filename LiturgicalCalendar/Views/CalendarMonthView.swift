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

    var body: some View {
        VStack(spacing: 0) {
            // Navigation
            HStack {
                Button { prevMonth() } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3.weight(.medium))
                }
                Spacer()
                Text(monthName)
                    .font(.custom("Georgia-Bold", size: 20))
                Spacer()
                Button { nextMonth() } label: {
                    Image(systemName: "chevron.right")
                        .font(.title3.weight(.medium))
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)

            // Weekday headers
            let headers = ["S","M","T","W","T","F","S"]
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 4) {
                ForEach(headers, id: \.self) { h in
                    Text(h)
                        .font(.custom("Georgia", size: 12))
                        .foregroundStyle(.secondary)
                }

                // Empty cells before first day
                ForEach(0..<(firstWeekday - 1), id: \.self) { _ in
                    Color.clear.frame(height: 48)
                }

                // Day cells
                ForEach(days) { day in
                    Button {
                        selectedDay = day
                        showDetail = true
                    } label: {
                        VStack(spacing: 2) {
                            Text("\(Foundation.day(of: day.date))")
                                .font(.custom("Georgia", size: 14))
                                .foregroundColor(day.color.textColor)
                            Circle()
                                .fill(day.color.color.opacity(0.6))
                                .frame(width: 4, height: 4)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(day.color.color.opacity(0.25))
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 12)

            Spacer()
        }
        .sheet(isPresented: $showDetail) {
            if let day = selectedDay {
                DayDetailView(day: day)
            }
        }
    }

    private func prevMonth() {
        if displayedMonth == 1 {
            displayedMonth = 12; displayedYear -= 1
        } else {
            displayedMonth -= 1
        }
    }

    private func nextMonth() {
        if displayedMonth == 12 {
            displayedMonth = 1; displayedYear += 1
        } else {
            displayedMonth += 1
        }
    }
}
