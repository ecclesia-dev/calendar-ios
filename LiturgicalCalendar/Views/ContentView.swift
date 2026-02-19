import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TodayView()
                .tabItem {
                    Label("Today", systemImage: "sun.max.fill")
                }

            NavigationStack {
                CalendarMonthView()
                    .navigationTitle("Calendar")
            }
            .tabItem {
                Label("Calendar", systemImage: "calendar")
            }

            NavigationStack {
                SanctoralListView()
            }
            .tabItem {
                Label("Saints", systemImage: "person.3.fill")
            }
        }
        .tint(.primary)
    }
}
