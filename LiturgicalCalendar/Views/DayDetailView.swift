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
                        VStack(spacing: 12) {
                            Text(day.date.formatted(.dateTime.weekday(.wide).month(.wide).day().year()))
                                .font(.custom("Georgia", size: 15))
                                .foregroundColor(day.color.textColor.opacity(0.8))

                            Text(day.celebration.titleVernacular)
                                .font(.custom("Georgia-Bold", size: 24))
                                .multilineTextAlignment(.center)
                                .foregroundColor(day.color.textColor)

                            Text(day.celebration.title)
                                .font(.custom("Georgia-Italic", size: 14))
                                .foregroundColor(day.color.textColor.opacity(0.7))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.vertical, 36)
                        .padding(.horizontal)
                    }

                    VStack(spacing: 16) {
                        infoRow("Rank", day.celebration.rank.displayName)
                        infoRow("Color", day.color.displayName)
                        infoRow("Season", day.season.displayName)
                        infoRow("Latin Season", day.season.latinName)
                        infoRow("Week", "\(day.week)")
                        infoRow("Category", day.celebration.category.rawValue.replacingOccurrences(of: "([A-Z])", with: " $1", options: .regularExpression).capitalized)

                        if !day.commemorations.isEmpty {
                            Divider().padding(.vertical, 4)
                            Text("Commemorations")
                                .font(.custom("Georgia-Bold", size: 13))
                                .textCase(.uppercase)
                                .tracking(2)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            ForEach(day.commemorations) { c in
                                HStack(alignment: .top, spacing: 10) {
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(c.color.color)
                                        .frame(width: 4)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(c.titleVernacular)
                                            .font(.custom("Georgia", size: 15))
                                        Text(c.title)
                                            .font(.custom("Georgia-Italic", size: 12))
                                            .foregroundStyle(.secondary)
                                        Text(c.rank.displayName)
                                            .font(.custom("Georgia", size: 11))
                                            .foregroundStyle(.tertiary)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    .padding(24)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .font(.custom("Georgia", size: 16))
                }
            }
        }
    }

    private func infoRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
                .font(.custom("Georgia", size: 12))
                .textCase(.uppercase)
                .tracking(1.5)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.custom("Georgia", size: 15))
        }
    }
}
