import Foundation

struct FixedFeast {
    let month: Int
    let day: Int
    let celebration: Celebration
}

func buildSanctoralCycle(year: Int) -> [Date: [Celebration]] {
    let feasts = majorFeasts()
    var map: [Date: [Celebration]] = [:]

    for feast in feasts {
        let date = makeDate(year: year, month: feast.month, day: feast.day)
        map[date, default: []].append(feast.celebration)
    }

    // Holy Name of Jesus: Sunday between Jan 2-5, or Jan 2
    let holyNameDate = findSundayBetween(year: year, m1: 1, d1: 2, m2: 1, d2: 5) ?? makeDate(year: year, month: 1, day: 2)
    map[holyNameDate, default: []].append(Celebration(
        id: "holy-name-of-jesus", title: "Ss.mi Nominis Jesu",
        titleVernacular: "The Most Holy Name of Jesus",
        rank: .classII, category: .feastOfLord, color: .white, precedence: 5
    ))

    // Holy Family: Sunday within Octave of Christmas
    let dec25prev = makeDate(year: year - 1, month: 12, day: 25)
    let holyFamilyDate: Date
    if weekday(of: dec25prev) == 1 { // Sunday
        holyFamilyDate = makeDate(year: year - 1, month: 12, day: 30)
    } else {
        var d = makeDate(year: year - 1, month: 12, day: 26)
        let end = makeDate(year: year, month: 1, day: 1)
        var found: Date?
        while d <= end {
            if weekday(of: d) == 1 { found = d; break }
            d = addDays(d, 1)
        }
        holyFamilyDate = found ?? makeDate(year: year - 1, month: 12, day: 30)
    }
    if Foundation.year(of: holyFamilyDate) == year {
        map[holyFamilyDate, default: []].append(Celebration(
            id: "holy-family", title: "Sanctae Familiae",
            titleVernacular: "The Holy Family",
            rank: .classI, category: .feastOfLord, color: .white, precedence: 4
        ))
    }

    return map
}

private func findSundayBetween(year: Int, m1: Int, d1: Int, m2: Int, d2: Int) -> Date? {
    var d = makeDate(year: year, month: m1, day: d1)
    let end = makeDate(year: year, month: m2, day: d2)
    while d <= end {
        if weekday(of: d) == 1 { return d }
        d = addDays(d, 1)
    }
    return nil
}

func majorFeasts() -> [FixedFeast] {
    func f(_ month: Int, _ day: Int, _ id: String, _ title: String, _ titleEn: String,
           _ rank: CelebrationRank, _ cat: CelebrationCategory, _ color: LiturgicalColor, _ prec: UInt8) -> FixedFeast {
        FixedFeast(month: month, day: day, celebration: Celebration(id: id, title: title, titleVernacular: titleEn, rank: rank, category: cat, color: color, precedence: prec))
    }
    return [
        // January
        f(1,1,"circumcision","In Circumcisione Domini","Circumcision of Our Lord",.classI,.feastOfLord,.white,4),
        f(1,6,"epiphany","In Epiphania Domini","The Epiphany of Our Lord",.classI,.feastOfLord,.white,4),
        f(1,25,"conversion-of-st-paul","Conversio S. Pauli","Conversion of St. Paul",.classIII,.feast,.white,9),
        f(1,28,"st-thomas-aquinas","S. Thomae de Aquino","St. Thomas Aquinas",.classIII,.feast,.white,9),
        // February
        f(2,2,"purification-bvm","In Purificatione B.M.V.","Purification of the BVM (Candlemas)",.classII,.feastOfLord,.white,5),
        f(2,22,"chair-of-st-peter","Cathedra S. Petri","Chair of St. Peter",.classII,.feast,.white,7),
        f(2,24,"st-matthias","S. Matthiae","St. Matthias, Apostle",.classII,.feast,.red,7),
        // March
        f(3,7,"st-perpetua-felicity","Ss. Perpetuae et Felicitatis","Sts. Perpetua and Felicity, Martyrs",.classIII,.feast,.red,9),
        f(3,12,"st-gregory-great","S. Gregorii I Papae","St. Gregory the Great, Pope and Doctor",.classIII,.feast,.white,9),
        f(3,17,"st-patrick","S. Patricii","St. Patrick, Bishop and Confessor",.classIII,.feast,.white,9),
        f(3,19,"st-joseph","S. Joseph Sponsi B.M.V.","St. Joseph, Spouse of the BVM",.classI,.solemnity,.white,4),
        f(3,25,"annunciation","In Annuntiatione B.M.V.","The Annunciation of the BVM",.classI,.feastOfLord,.white,4),
        // April
        f(4,2,"st-francis-of-paola","S. Francisci de Paula","St. Francis of Paola, Confessor",.classIII,.feast,.white,9),
        f(4,25,"st-mark","S. Marci","St. Mark, Evangelist",.classII,.feast,.red,7),
        // May
        f(5,1,"st-joseph-worker","S. Joseph Opificis","St. Joseph the Worker",.classI,.solemnity,.white,4),
        f(5,3,"finding-holy-cross","Inventio S. Crucis","Finding of the Holy Cross",.classIII,.feast,.red,9),
        f(5,11,"ss-philip-james","Ss. Philippi et Jacobi","Sts. Philip and James, Apostles",.classII,.feast,.red,7),
        f(5,31,"queenship-of-mary","B.M.V. Reginae","Queenship of the BVM",.classII,.feast,.white,7),
        // June
        f(6,24,"nativity-of-st-john-baptist","In Nativitate S. Joannis Baptistae","Nativity of St. John the Baptist",.classI,.solemnity,.white,4),
        f(6,29,"ss-peter-paul","Ss. Petri et Pauli","Sts. Peter and Paul, Apostles",.classI,.solemnity,.red,4),
        // July
        f(7,2,"visitation-bvm","Visitatio B.M.V.","Visitation of the BVM",.classII,.feast,.white,7),
        f(7,25,"st-james-greater","S. Jacobi Majoris","St. James the Greater, Apostle",.classII,.feast,.red,7),
        f(7,26,"st-anne","S. Annae Matris B.M.V.","St. Anne, Mother of the BVM",.classII,.feast,.white,7),
        // August
        f(8,6,"transfiguration","In Transfiguratione Domini","The Transfiguration of Our Lord",.classII,.feastOfLord,.white,5),
        f(8,10,"st-lawrence","S. Laurentii","St. Lawrence, Martyr",.classII,.feast,.red,7),
        f(8,15,"assumption-bvm","In Assumptione B.M.V.","The Assumption of the BVM",.classI,.solemnity,.white,4),
        f(8,22,"immaculate-heart-of-mary","Immaculati Cordis B.M.V.","Immaculate Heart of Mary",.classII,.feast,.white,7),
        f(8,24,"st-bartholomew","S. Bartholomaei","St. Bartholomew, Apostle",.classII,.feast,.red,7),
        f(8,28,"st-augustine","S. Augustini","St. Augustine, Bishop and Doctor",.classIII,.feast,.white,9),
        f(8,29,"beheading-john-baptist","In Decollatione S. Joannis Baptistae","Beheading of St. John the Baptist",.classIII,.feast,.red,9),
        // September
        f(9,8,"nativity-bvm","In Nativitate B.M.V.","Nativity of the BVM",.classII,.feast,.white,7),
        f(9,14,"exaltation-holy-cross","In Exaltatione S. Crucis","Exaltation of the Holy Cross",.classII,.feastOfLord,.red,5),
        f(9,15,"seven-sorrows-bvm","Septem Dolorum B.M.V.","Seven Sorrows of the BVM",.classII,.feast,.white,7),
        f(9,21,"st-matthew","S. Matthaei","St. Matthew, Apostle and Evangelist",.classII,.feast,.red,7),
        f(9,29,"st-michael","Dedicatio S. Michaelis Archangeli","St. Michael the Archangel",.classI,.solemnity,.white,4),
        // October
        f(10,7,"holy-rosary","B.M.V. a Rosario","Our Lady of the Rosary",.classII,.feast,.white,7),
        f(10,11,"divine-motherhood-bvm","Maternitatis B.M.V.","Divine Motherhood of the BVM",.classII,.feast,.white,7),
        f(10,18,"st-luke","S. Lucae","St. Luke, Evangelist",.classII,.feast,.red,7),
        f(10,28,"ss-simon-jude","Ss. Simonis et Judae","Sts. Simon and Jude, Apostles",.classII,.feast,.red,7),
        // November
        f(11,1,"all-saints","Omnium Sanctorum","All Saints",.classI,.solemnity,.white,4),
        f(11,2,"all-souls","In Commemoratione Omnium Fidelium Defunctorum","All Souls Day",.classI,.solemnity,.black,4),
        f(11,9,"dedication-lateran","Dedicatio Archibasilicae Ss.mi Salvatoris","Dedication of the Lateran Basilica",.classII,.feast,.white,7),
        f(11,11,"st-martin-of-tours","S. Martini Episcopi","St. Martin of Tours, Bishop",.classIII,.feast,.white,9),
        f(11,21,"presentation-bvm","Praesentatio B.M.V.","Presentation of the BVM",.classIII,.feast,.white,9),
        f(11,22,"st-cecilia","S. Caeciliae","St. Cecilia, Virgin and Martyr",.classIII,.feast,.red,9),
        f(11,25,"st-catherine-of-alexandria","S. Catharinae","St. Catherine of Alexandria, Virgin and Martyr",.classIII,.feast,.red,9),
        f(11,30,"st-andrew","S. Andreae","St. Andrew, Apostle",.classII,.feast,.red,7),
        // December
        f(12,8,"immaculate-conception","In Conceptione Immaculata B.M.V.","Immaculate Conception of the BVM",.classI,.solemnity,.white,4),
        f(12,21,"st-thomas-apostle","S. Thomae Apostoli","St. Thomas, Apostle",.classII,.feast,.red,7),
        f(12,25,"christmas","In Nativitate Domini","The Nativity of Our Lord",.classI,.solemnity,.white,1),
        f(12,26,"st-stephen","S. Stephani Protomartyris","St. Stephen, Protomartyr",.classII,.feast,.red,5),
        f(12,27,"st-john-evangelist","S. Joannis Apostoli et Evangelistae","St. John, Apostle and Evangelist",.classII,.feast,.white,5),
        f(12,28,"holy-innocents","Ss. Innocentium","Holy Innocents",.classII,.feast,.red,5),
        f(12,31,"st-sylvester","S. Silvestri I","St. Sylvester I, Pope",.classIII,.feast,.white,9),
    ]
}
