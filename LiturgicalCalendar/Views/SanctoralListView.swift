import SwiftUI

struct SanctoralListView: View {
    let feasts = majorFeasts()

    private var grouped: [(String, [FixedFeast])] {
        let months = ["", "January", "February", "March", "April", "May", "June",
                       "July", "August", "September", "October", "November", "December"]
        let byMonth = Dictionary(grouping: feasts) { $0.month }
        return byMonth.keys.sorted().map { m in (months[m], byMonth[m]!.sorted { $0.day < $1.day }) }
    }

    var body: some View {
        List {
            ForEach(grouped, id: \.0) { monthName, feasts in
                Section {
                    ForEach(feasts, id: \.celebration.id) { feast in
                        HStack(spacing: 12) {
                            // Color bar
                            RoundedRectangle(cornerRadius: 2)
                                .fill(feast.celebration.color.color)
                                .frame(width: 5)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(feast.celebration.titleVernacular)
                                    .font(.custom("Georgia", size: 15))
                                    .foregroundColor(LiturgicalTheme.bodyText)
                                Text(feast.celebration.title)
                                    .font(.custom("Georgia-Italic", size: 12))
                                    .foregroundColor(LiturgicalTheme.subtitleText)
                                HStack(spacing: 6) {
                                    Text("\(monthAbbr(feast.month)) \(feast.day)")
                                        .font(.custom("Georgia", size: 11))
                                    Text("•")
                                    Text(feast.celebration.rank.displayName)
                                        .font(.custom("Georgia", size: 11))
                                    Text("•")
                                    Text(feast.celebration.color.displayName)
                                        .font(.custom("Georgia", size: 11))
                                }
                                .foregroundColor(LiturgicalTheme.subtitleText.opacity(0.7))
                            }
                            Spacer()
                        }
                        .padding(.vertical, 4)
                        .listRowBackground(LiturgicalTheme.cardBackground)
                    }
                } header: {
                    Text(monthName)
                        .font(.custom("Georgia-Bold", size: 14))
                        .foregroundColor(LiturgicalTheme.burgundy)
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(LiturgicalTheme.background)
        .navigationTitle("Sanctoral Cycle")
    }

    private func monthAbbr(_ m: Int) -> String {
        let a = ["","Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
        return a[m]
    }
}
