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
                Section(header: Text(monthName).font(.custom("Georgia-Bold", size: 14))) {
                    ForEach(feasts, id: \.celebration.id) { feast in
                        HStack(spacing: 12) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(feast.celebration.color.color)
                                .frame(width: 6)
                            VStack(alignment: .leading, spacing: 3) {
                                Text(feast.celebration.titleVernacular)
                                    .font(.custom("Georgia", size: 15))
                                Text(feast.celebration.title)
                                    .font(.custom("Georgia-Italic", size: 12))
                                    .foregroundStyle(.secondary)
                                HStack {
                                    Text("\(monthAbbr(feast.month)) \(feast.day)")
                                        .font(.custom("Georgia", size: 11))
                                        .foregroundStyle(.tertiary)
                                    Text("•")
                                        .foregroundStyle(.tertiary)
                                    Text(feast.celebration.rank.displayName)
                                        .font(.custom("Georgia", size: 11))
                                        .foregroundStyle(.tertiary)
                                }
                            }
                            Spacer()
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Sanctoral Cycle")
    }

    private func monthAbbr(_ m: Int) -> String {
        let a = ["","Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
        return a[m]
    }
}
