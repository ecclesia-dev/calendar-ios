import SwiftUI

struct SettingsView: View {
    @ObservedObject private var notifications = NotificationManager.shared
    @State private var selectedTime: Date

    init() {
        let nm = NotificationManager.shared
        var comps = DateComponents()
        comps.hour = nm.notificationHour
        comps.minute = nm.notificationMinute
        let date = Calendar(identifier: .gregorian).date(from: comps) ?? Date()
        _selectedTime = State(initialValue: date)
    }

    var body: some View {
        List {
            Section {
                VStack(spacing: 8) {
                    Text(LiturgicalTheme.cross)
                        .font(.system(size: 32))
                        .foregroundColor(LiturgicalTheme.gold)
                    Text("Liturgical Calendar")
                        .font(.custom("Georgia-Bold", size: 20))
                        .foregroundColor(LiturgicalTheme.bodyText)
                    Text("1962 Roman Calendar")
                        .font(.custom("Georgia-Italic", size: 14))
                        .foregroundColor(LiturgicalTheme.subtitleText)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .listRowBackground(LiturgicalTheme.parchment)
            }

            Section {
                Toggle(isOn: $notifications.isEnabled) {
                    Label {
                        Text("Daily Notification")
                            .font(.custom("Georgia", size: 15))
                    } icon: {
                        Image(systemName: "bell.fill")
                            .foregroundColor(LiturgicalTheme.gold)
                    }
                }
                .tint(LiturgicalTheme.burgundy)
                .onChange(of: notifications.isEnabled) { _, newValue in
                    if newValue {
                        notifications.requestPermission()
                    } else {
                        notifications.disable()
                    }
                }

                if notifications.isEnabled {
                    DatePicker(
                        selection: $selectedTime,
                        displayedComponents: .hourAndMinute
                    ) {
                        Label {
                            Text("Time")
                                .font(.custom("Georgia", size: 15))
                        } icon: {
                            Image(systemName: "clock.fill")
                                .foregroundColor(LiturgicalTheme.gold)
                        }
                    }
                    .onChange(of: selectedTime) { _, newValue in
                        let cal = Calendar(identifier: .gregorian)
                        notifications.notificationHour = cal.component(.hour, from: newValue)
                        notifications.notificationMinute = cal.component(.minute, from: newValue)
                    }
                }
            } header: {
                Text("Notifications")
                    .font(.custom("Georgia-Bold", size: 12))
                    .foregroundColor(LiturgicalTheme.burgundy)
            } footer: {
                Text("Receive the day's feast name, rank, and liturgical color each morning.")
                    .font(.custom("Georgia", size: 12))
                    .foregroundColor(LiturgicalTheme.subtitleText)
            }

            Section {
                infoRow("Calendar", "1962 Roman (Tridentine)")
                infoRow("Rubrics", "1960 Code of Rubrics")
                infoRow("Temporal Cycle", "Computus-based")
                infoRow("Sanctoral Cycle", "Major feasts embedded")
            } header: {
                Text("About")
                    .font(.custom("Georgia-Bold", size: 12))
                    .foregroundColor(LiturgicalTheme.burgundy)
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(LiturgicalTheme.background)
        .navigationTitle("Settings")
    }

    private func infoRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
                .font(.custom("Georgia", size: 14))
                .foregroundColor(LiturgicalTheme.bodyText)
            Spacer()
            Text(value)
                .font(.custom("Georgia", size: 13))
                .foregroundColor(LiturgicalTheme.subtitleText)
        }
    }
}
