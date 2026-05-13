import Foundation
import os

enum AppLog {
    static let subsystem = Bundle.main.bundleIdentifier ?? "nl.homing"
    static let state = Logger(subsystem: subsystem, category: "state")
    static let net = Logger(subsystem: subsystem, category: "net")
    static let telemetry = Logger(subsystem: subsystem, category: "telemetry")
}
