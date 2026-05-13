import Foundation

enum MenuBarState: Equatable {
    case notConfigured
    case drivingHome(minutesToArrival: Int)
    case drivingElsewhere(minutesToArrival: Int)
    case parkedAllClosed
    case parkedSomethingOpen(count: Int)
    case parkedHomeAsleep
    case asleep
    case offline
    case error(message: String)

    var systemImage: String? {
        switch self {
        case .notConfigured: return "gear"
        case .drivingHome, .drivingElsewhere: return nil
        case .parkedAllClosed: return "car.fill"
        case .parkedSomethingOpen: return "car.fill"
        case .parkedHomeAsleep: return "house.fill"
        case .asleep: return "car"
        case .offline: return "car.slash"
        case .error: return "exclamationmark.triangle"
        }
    }

    var label: String {
        switch self {
        case .notConfigured: return ""
        case .drivingHome(let m): return formattedMinutes(m)
        case .drivingElsewhere(let m): return formattedMinutes(m)
        case .parkedAllClosed: return ""
        case .parkedSomethingOpen(let c): return c > 1 ? "\(c)" : ""
        case .parkedHomeAsleep: return ""
        case .asleep: return ""
        case .offline: return ""
        case .error: return ""
        }
    }

    var showsTrailingDot: Bool {
        switch self {
        case .drivingElsewhere: return true
        case .parkedSomethingOpen(let c): return c <= 1
        default: return false
        }
    }

    private func formattedMinutes(_ minutes: Int) -> String {
        "\(max(0, minutes)) min"
    }
}
