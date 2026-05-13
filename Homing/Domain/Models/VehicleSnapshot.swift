import Foundation
import CoreLocation

struct VehicleSnapshot: Equatable, Codable {
    var vehicle: Vehicle
    var drive: DriveState
    var climate: ClimateState
    var batteryLevel: Int
    var batteryRangeKm: Double?
    var chargePortOpen: Bool
    var charging: Bool
    var doorsOpen: [String]
    var windowsOpen: [String]
    var trunkOpen: Bool
    var frunkOpen: Bool
    var lastUpdate: Date

    var anyOpen: Bool {
        !doorsOpen.isEmpty || !windowsOpen.isEmpty || trunkOpen || frunkOpen
    }

    var openCount: Int {
        doorsOpen.count + windowsOpen.count + (trunkOpen ? 1 : 0) + (frunkOpen ? 1 : 0)
    }

    static func placeholder(id: String = "preview-1", vin: String = "5YJ3PREVIEW") -> VehicleSnapshot {
        VehicleSnapshot(
            vehicle: Vehicle(id: id, vin: vin, displayName: "Tesla", state: .online),
            drive: .unknown,
            climate: .unknown,
            batteryLevel: 72,
            batteryRangeKm: 320,
            chargePortOpen: false,
            charging: false,
            doorsOpen: [],
            windowsOpen: [],
            trunkOpen: false,
            frunkOpen: false,
            lastUpdate: Date()
        )
    }
}
