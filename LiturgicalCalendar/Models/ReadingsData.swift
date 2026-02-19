import Foundation

/// Propers/readings references for major feasts and Sundays (1962 Missal).
/// Full text would require a large database; we provide references.
struct ReadingsReference {
    let epistle: String
    let gospel: String
    let introit: String?
    let collect: String?

    static func forCelebration(_ id: String) -> ReadingsReference? {
        readings[id]
    }
}

private let readings: [String: ReadingsReference] = [
    // Major Temporal
    "easter-sunday": ReadingsReference(epistle: "1 Cor 5:7-8", gospel: "Mark 16:1-7", introit: "Ps 138:18, 5-6", collect: nil),
    "christmas": ReadingsReference(epistle: "Titus 2:11-15", gospel: "Luke 2:1-14", introit: "Ps 2:7", collect: nil),
    "pentecost": ReadingsReference(epistle: "Acts 2:1-11", gospel: "John 14:23-31", introit: "Wis 1:7", collect: nil),
    "ascension": ReadingsReference(epistle: "Acts 1:1-11", gospel: "Mark 16:14-20", introit: "Acts 1:11", collect: nil),
    "ash-wednesday": ReadingsReference(epistle: "Joel 2:12-19", gospel: "Matt 6:16-21", introit: "Wis 11:24-25, 27", collect: nil),
    "palm-sunday": ReadingsReference(epistle: "Phil 2:5-11", gospel: "Matt 26:36—27:60", introit: "Ps 21:20-22", collect: nil),
    "holy-thursday": ReadingsReference(epistle: "1 Cor 11:20-32", gospel: "John 13:1-15", introit: "Gal 6:14", collect: nil),
    "good-friday": ReadingsReference(epistle: "Osee 6:1-6", gospel: "John 18:1—19:42", introit: nil, collect: nil),
    "corpus-christi": ReadingsReference(epistle: "1 Cor 11:23-29", gospel: "John 6:56-59", introit: "Ps 80:17", collect: nil),
    "sacred-heart": ReadingsReference(epistle: "Eph 3:8-19", gospel: "John 19:31-37", introit: "Ps 32:11, 19", collect: nil),

    // Fixed feasts
    "circumcision": ReadingsReference(epistle: "Titus 2:11-15", gospel: "Luke 2:21", introit: "Is 9:6", collect: nil),
    "epiphany": ReadingsReference(epistle: "Is 60:1-6", gospel: "Matt 2:1-12", introit: "Mal 3:1", collect: nil),
    "purification-bvm": ReadingsReference(epistle: "Mal 3:1-4", gospel: "Luke 2:22-32", introit: "Ps 47:10-11", collect: nil),
    "st-joseph": ReadingsReference(epistle: "Ecclus 45:1-6", gospel: "Matt 1:18-21", introit: "Ps 91:13-14", collect: nil),
    "annunciation": ReadingsReference(epistle: "Is 7:10-15", gospel: "Luke 1:26-38", introit: "Ps 44:13", collect: nil),
    "nativity-of-st-john-baptist": ReadingsReference(epistle: "Is 49:1-3, 5-7", gospel: "Luke 1:57-68", introit: "Is 49:1-2", collect: nil),
    "ss-peter-paul": ReadingsReference(epistle: "Acts 12:1-11", gospel: "Matt 16:13-19", introit: "Acts 12:11", collect: nil),
    "transfiguration": ReadingsReference(epistle: "2 Pet 1:16-19", gospel: "Matt 17:1-9", introit: "Ps 76:19", collect: nil),
    "assumption-bvm": ReadingsReference(epistle: "Judith 13:22-25; 15:10", gospel: "Luke 1:41-50", introit: "Apoc 12:1", collect: nil),
    "st-michael": ReadingsReference(epistle: "Apoc 1:1-5", gospel: "Matt 18:1-10", introit: "Ps 102:20", collect: nil),
    "all-saints": ReadingsReference(epistle: "Apoc 7:2-12", gospel: "Matt 5:1-12", introit: "Ps 32:1", collect: nil),
    "all-souls": ReadingsReference(epistle: "1 Cor 15:51-57", gospel: "John 5:25-29", introit: "4 Esd 2:34-35", collect: nil),
    "immaculate-conception": ReadingsReference(epistle: "Prov 8:22-35", gospel: "Luke 1:26-28", introit: "Is 61:10", collect: nil),
    "christ-the-king": ReadingsReference(epistle: "Col 1:12-20", gospel: "John 18:33-37", introit: "Apoc 5:12; 1:6", collect: nil),

    // Sundays after Pentecost (selected)
    "sunday-afterPentecost-1": ReadingsReference(epistle: "1 John 4:8-21", gospel: "Luke 6:36-42", introit: "Ps 12:6", collect: nil),
    "sunday-afterPentecost-2": ReadingsReference(epistle: "1 John 3:13-18", gospel: "Luke 14:16-24", introit: "Ps 17:19-20", collect: nil),

    // Advent Sundays
    "sunday-advent-1": ReadingsReference(epistle: "Rom 13:11-14", gospel: "Luke 21:25-33", introit: "Ps 24:1-3", collect: nil),
    "sunday-advent-2": ReadingsReference(epistle: "Rom 15:4-13", gospel: "Matt 11:2-10", introit: "Ps 79:2-3", collect: nil),
    "sunday-advent-3": ReadingsReference(epistle: "Phil 4:4-7", gospel: "John 1:19-28", introit: "Phil 4:4-5", collect: nil),
    "sunday-advent-4": ReadingsReference(epistle: "1 Cor 4:1-5", gospel: "Luke 3:1-6", introit: "Is 45:8", collect: nil),

    // Lent Sundays
    "sunday-lent-1": ReadingsReference(epistle: "2 Cor 6:1-10", gospel: "Matt 4:1-11", introit: "Ps 90:15-16", collect: nil),
    "sunday-lent-2": ReadingsReference(epistle: "1 Thess 4:1-7", gospel: "Matt 17:1-9", introit: "Ps 24:6, 3, 22", collect: nil),
    "sunday-lent-3": ReadingsReference(epistle: "Eph 5:1-9", gospel: "Luke 11:14-28", introit: "Ps 24:15-16", collect: nil),
    "sunday-lent-4": ReadingsReference(epistle: "Gal 4:22-31", gospel: "John 6:1-15", introit: "Is 66:10-11", collect: nil),
]
