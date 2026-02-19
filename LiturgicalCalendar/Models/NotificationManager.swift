import Foundation
import UserNotifications

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()

    @Published var isEnabled: Bool {
        didSet { UserDefaults.standard.set(isEnabled, forKey: "notificationsEnabled") }
    }
    @Published var notificationHour: Int {
        didSet {
            UserDefaults.standard.set(notificationHour, forKey: "notificationHour")
            if isEnabled { scheduleDailyNotification() }
        }
    }
    @Published var notificationMinute: Int {
        didSet {
            UserDefaults.standard.set(notificationMinute, forKey: "notificationMinute")
            if isEnabled { scheduleDailyNotification() }
        }
    }

    private init() {
        self.isEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        self.notificationHour = UserDefaults.standard.object(forKey: "notificationHour") as? Int ?? 7
        self.notificationMinute = UserDefaults.standard.object(forKey: "notificationMinute") as? Int ?? 0
    }

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async {
                if granted {
                    self.isEnabled = true
                    self.scheduleDailyNotification()
                }
            }
        }
    }

    func scheduleDailyNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["daily-feast"])

        guard isEnabled else { return }

        // Schedule for next 7 days
        let engine = LiturgicalCalendarEngine.shared
        let cal = Calendar(identifier: .gregorian)

        for dayOffset in 0..<7 {
            guard let targetDate = cal.date(byAdding: .day, value: dayOffset, to: Date()) else { continue }
            let comps = cal.dateComponents([.year, .month, .day], from: targetDate)
            let normalized = makeDate(year: comps.year!, month: comps.month!, day: comps.day!)

            guard let day = engine.day(for: normalized) else { continue }

            let content = UNMutableNotificationContent()
            content.title = "\(LiturgicalTheme.cross) \(day.celebration.titleVernacular)"
            content.subtitle = "\(day.celebration.rank.displayName) — \(day.color.displayName)"
            content.body = "\(day.season.displayName) • \(day.celebration.title)"
            content.sound = .default

            var trigger = DateComponents()
            trigger.year = comps.year
            trigger.month = comps.month
            trigger.day = comps.day
            trigger.hour = notificationHour
            trigger.minute = notificationMinute

            let request = UNNotificationRequest(
                identifier: "daily-feast-\(dayOffset)",
                content: content,
                trigger: UNCalendarNotificationTrigger(dateMatching: trigger, repeats: false)
            )
            center.add(request)
        }
    }

    func disable() {
        isEnabled = false
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers:
            (0..<7).map { "daily-feast-\($0)" }
        )
    }
}
