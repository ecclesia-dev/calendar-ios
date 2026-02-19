import SwiftUI

enum LiturgicalTheme {
    // Base palette
    static let cream = Color(red: 0.98, green: 0.96, blue: 0.91)
    static let parchment = Color(red: 0.95, green: 0.92, blue: 0.85)
    static let burgundy = Color(red: 0.55, green: 0.09, blue: 0.13)
    static let darkBurgundy = Color(red: 0.40, green: 0.06, blue: 0.10)
    static let gold = Color(red: 0.76, green: 0.63, blue: 0.22)
    static let darkGold = Color(red: 0.60, green: 0.49, blue: 0.15)
    static let inkBrown = Color(red: 0.25, green: 0.20, blue: 0.15)
    static let fadedInk = Color(red: 0.45, green: 0.38, blue: 0.30)

    // Semantic
    static let background = cream
    static let cardBackground = Color.white
    static let headerText = burgundy
    static let bodyText = inkBrown
    static let subtitleText = fadedInk
    static let accent = gold
    static let divider = gold.opacity(0.3)

    // Ornamental cross character
    static let cross = "✠"
}
