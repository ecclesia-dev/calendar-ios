# Liturgical Calendar for iOS

**The 1962 liturgical calendar on your iPhone.**

`1962 Rubrics · Temporal & Sanctoral Cycles · Home Screen Widget · Daily Notifications`

A native iOS app implementing the traditional Roman liturgical calendar (1962 Missale Romanum). See today's feast, liturgical color, season, rank, and Mass readings at a glance. Includes a home screen widget.

---

## Features

- **Today view** — hero banner with the liturgical color, feast name (English and Latin), rank (I–IV Class), season, and Mass readings references
- **Monthly calendar** — browse any month with color-coded days showing feast ranks
- **Saints list** — browse the sanctoral cycle sorted by precedence
- **Full calendar engine** — computes the temporal cycle (Advent through Christ the King), sanctoral cycle (fixed feasts), and resolves precedence conflicts per 1962 rubrics
- **Computus** — calculates Easter and all moveable feasts
- **All liturgical seasons** — Advent, Christmastide, Time after Epiphany, Septuagesima, Lent, Passiontide, Holy Week, Eastertide, Ascensiontide, Time after Pentecost
- **Seven liturgical colors** — white, red, green, violet, rose, black, gold — rendered as full-screen banners
- **Readings references** — Epistle, Gospel, and Introit references for each celebration
- **Home screen widget** — shows today's feast, color, and date; updates daily
- **Daily notifications** — optional reminder with the day's feast
- **Settings** — notification preferences
- **Offline** — the entire calendar is computed locally; no network needed

## Calendar System

The engine implements the 1962 rubrical rules:

- **Temporal cycle** — Sundays, feriae, privileged feriae, ember days, rogation days
- **Sanctoral cycle** — fixed feasts from the General Roman Calendar
- **Precedence resolution** — when temporal and sanctoral collide, the higher-ranked celebration wins; the other is commemorated
- **Celebration ranks** — I. Class, II. Class, III. Class, IV. Class, Privileged Feria, Feria

## Widget

The WidgetKit extension provides small and medium home screen widgets showing:

- Feast name and Latin title
- Liturgical color background
- Rank badge
- Day and month

Updates automatically at midnight.

## Requirements

- iOS 17.0+
- Xcode 15+

## Build

```sh
git clone https://github.com/ecclesia-dev/calendar-ios.git
cd calendar-ios
open LiturgicalCalendar.xcodeproj
```

Build and run. No external dependencies.

## Related Projects

| Project | Description |
|---------|-------------|
| **[drb-ios](https://github.com/ecclesia-dev/drb-ios)** | Douay-Rheims Bible for iOS |
| **[rosary-ios](https://github.com/ecclesia-dev/rosary-ios)** | Holy Rosary app for iOS |
| **[lectionary](https://github.com/ecclesia-dev/lectionary)** | TLM Daily Mass Readings (terminal) |
| **[martyrology](https://github.com/ecclesia-dev/martyrology)** | Roman Martyrology (terminal) |

*Ad Maiorem Dei Gloriam.*
