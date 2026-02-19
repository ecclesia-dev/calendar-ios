import SwiftUI

struct TodayView: View {
    let engine = LiturgicalCalendarEngine.shared
    @State private var today: LiturgicalDay?

    var body: some View {
        ScrollView {
            if let day = today {
                VStack(spacing: 0) {
                    // Hero banner
                    ZStack {
                        day.color.color
                            .ignoresSafeArea(edges: .top)
                        VStack(spacing: 16) {
                            Text(day.date.formatted(.dateTime.weekday(.wide)))
                                .font(.custom("Georgia", size: 14))
                                .textCase(.uppercase)
                                .tracking(3)
                                .foregroundColor(day.color.textColor.opacity(0.7))
                            Text(day.date.formatted(.dateTime.month(.wide).day()))
                                .font(.custom("Georgia", size: 18))
                                .foregroundColor(day.color.textColor.opacity(0.8))
                            Divider()
                                .frame(width: 60)
                                .overlay(day.color.textColor.opacity(0.3))

                            Text(day.celebration.titleVernacular)
                                .font(.custom("Georgia-Bold", size: 28))
                                .multilineTextAlignment(.center)
                                .foregroundColor(day.color.textColor)
                                .padding(.horizontal)

                            Text(day.celebration.title)
                                .font(.custom("Georgia-Italic", size: 16))
                                .multilineTextAlignment(.center)
                                .foregroundColor(day.color.textColor.opacity(0.75))
                                .padding(.horizontal)
                        }
                        .padding(.vertical, 48)
                    }

                    // Details card
                    VStack(spacing: 20) {
                        detailRow(label: "Rank", value: day.celebration.rank.displayName)
                        detailRow(label: "Color", value: day.color.displayName, color: day.color.color)
                        detailRow(label: "Season", value: day.season.displayName)
                        detailRow(label: "Tempus", value: day.season.latinName)

                        if !day.commemorations.isEmpty {
                            Divider()
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Commemorations")
                                    .font(.custom("Georgia-Bold", size: 14))
                                    .textCase(.uppercase)
                                    .tracking(2)
                                    .foregroundStyle(.secondary)
                                ForEach(day.commemorations) { comm in
                                    HStack {
                                        Circle()
                                            .fill(comm.color.color)
                                            .frame(width: 8, height: 8)
                                        VStack(alignment: .leading) {
                                            Text(comm.titleVernacular)
                                                .font(.custom("Georgia", size: 15))
                                            Text(comm.title)
                                                .font(.custom("Georgia-Italic", size: 12))
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(24)
                }
            } else {
                ProgressView()
                    .padding(100)
            }
        }
        .background(Color(.systemGroupedBackground))
        .onAppear { today = engine.today() }
    }

    private func detailRow(label: String, value: String, color: Color? = nil) -> some View {
        HStack {
            Text(label)
                .font(.custom("Georgia", size: 13))
                .textCase(.uppercase)
                .tracking(2)
                .foregroundStyle(.secondary)
            Spacer()
            HStack(spacing: 6) {
                if let c = color {
                    Circle().fill(c).frame(width: 10, height: 10)
                }
                Text(value)
                    .font(.custom("Georgia", size: 16))
            }
        }
    }
}
