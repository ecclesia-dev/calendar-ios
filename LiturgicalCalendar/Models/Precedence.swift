import Foundation

func resolvePrecedence(temporal: Celebration, sanctoral: [Celebration]) -> (Celebration, [Celebration]) {
    var all = [temporal] + sanctoral
    all.sort { a, b in
        if a.precedence != b.precedence { return a.precedence < b.precedence }
        return a.rank.rawValue < b.rank.rawValue
    }

    let winner = all[0]
    var commemorations: [Celebration] = []

    for c in all.dropFirst() {
        if c.rank != .feria {
            commemorations.append(c)
        }
    }

    return (winner, commemorations)
}
