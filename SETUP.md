# Homing — setup

Fase 1 uit `README.md`: skeleton + mock. Alle bronbestanden staan in
`Homing/`; unit tests in `HomingTests/`.

## Bouwen via Swift Package Manager (alleen core + tests)

Op macOS 14+:

```bash
swift build
swift test
```

Dit compileert alles behalve `App/HomingApp.swift` (de `@main`
`MenuBarExtra` entry point hoort in een echt app-target).

## Bouwen als menubar-app (Xcode-project)

`MenuBarExtra(.window)` vereist een echt macOS-app-target met een `.app`
bundle. Het Xcode-project staat (nog) niet in git omdat het op deze
Linux-omgeving niet aangemaakt kan worden. Maak het zo aan:

1. Open Xcode → **File → New → Project → macOS → App**.
2. Product name: `Homing`. Interface: SwiftUI. Language: Swift.
   Minimum deployment: **macOS 14.0**. Bundle identifier: bv.
   `nl.<jouw-handle>.homing`.
3. Sla het project op in de root van deze repo (zodat
   `Homing.xcodeproj` naast `Homing/` komt te staan).
4. In Xcode → het auto-aangemaakte `ContentView.swift` en
   `HomingApp.swift` verwijderen.
5. Sleep de bestaande mappen in `Homing/` (`App`, `Domain`,
   `Features`, `Infra`, `Resources`) als group-references naar het
   target. Vink **Copy items if needed** uit.
6. Voeg een Unit-test-target toe (`HomingTests`) en voeg de
   bestanden uit `HomingTests/` toe.
7. Build & run → menubar-icoon verschijnt; klik geeft de debug-picker
   met alle scenario's uit `MockTeslaClient.Scenario`.

## Verificatie Fase 1

- `swift test` → `VehicleStateMachineTests`, `LocationClassifierTests`
  en `MenuBarLabelViewModelTests` slagen.
- In Xcode: alle 9 cases van `MenuBarState` worden gerenderd in de
  `MenuBarLabelView` preview, en de debug-picker schakelt tussen
  scenario's.

## Volgende fasen

Fase 2A (Cloudflare Worker) en 2B (Tesla integratie) blokkeren nog op
de open vragen in `README.md` (eigen domein, Tesla developer account,
shared secret). Zodra die antwoorden er zijn: `cloudflare/` aanmaken
volgens de structuur in de README.
