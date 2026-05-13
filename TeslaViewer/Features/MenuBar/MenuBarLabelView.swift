import SwiftUI

struct MenuBarLabelView: View {
    let state: MenuBarState

    var body: some View {
        HStack(spacing: 4) {
            if let systemImage = state.systemImage {
                Image(systemName: systemImage)
                    .imageScale(.medium)
            }
            if !state.label.isEmpty {
                Text(state.label)
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .monospacedDigit()
                    .contentTransition(.numericText())
            }
            if state.showsTrailingDot {
                Circle()
                    .fill(Color.orange)
                    .frame(width: 4, height: 4)
                    .accessibilityHidden(true)
            }
        }
        .accessibilityLabel(accessibilityDescription)
    }

    private var accessibilityDescription: String {
        switch state {
        case .notConfigured: return "Tesla Viewer not configured"
        case .drivingHome(let m): return "Driving home, \(m) minutes to arrival"
        case .drivingElsewhere(let m): return "Driving, \(m) minutes to arrival"
        case .parkedAllClosed: return "Parked, all closed"
        case .parkedSomethingOpen(let c): return "Parked, \(c) item open"
        case .parkedHomeAsleep: return "Parked at home, asleep"
        case .asleep: return "Asleep"
        case .offline: return "Offline"
        case .error(let m): return "Error: \(m)"
        }
    }
}

#if DEBUG
struct MenuBarLabelView_Previews: PreviewProvider {
    static var previews: some View {
        let states: [MenuBarState] = [
            .notConfigured,
            .drivingHome(minutesToArrival: 14),
            .drivingElsewhere(minutesToArrival: 23),
            .parkedAllClosed,
            .parkedSomethingOpen(count: 2),
            .parkedHomeAsleep,
            .asleep,
            .offline,
            .error(message: "boom")
        ]
        VStack(alignment: .leading, spacing: 8) {
            ForEach(0..<states.count, id: \.self) { i in
                MenuBarLabelView(state: states[i])
            }
        }
        .padding()
    }
}
#endif
