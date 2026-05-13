import Foundation
import CoreLocation

final class MockTeslaClient: TeslaClient {
    enum Scenario: String, CaseIterable, Identifiable {
        case notConfigured
        case drivingHome
        case drivingElsewhere
        case parkedAllClosed
        case parkedSomethingOpen
        case parkedHomeAsleep
        case asleep
        case offline
        case error

        var id: String { rawValue }
    }

    static let home = CLLocationCoordinate2D(latitude: 52.3676, longitude: 4.9041)
    static let away = CLLocationCoordinate2D(latitude: 52.0907, longitude: 5.1214)
    static let work = CLLocationCoordinate2D(latitude: 51.9244, longitude: 4.4777)

    var scenario: Scenario

    init(scenario: Scenario = .parkedAllClosed) {
        self.scenario = scenario
    }

    func listVehicles() async throws -> [Vehicle] {
        switch scenario {
        case .error: throw TeslaClientError.server(status: 503)
        case .offline:
            return [Vehicle(id: "1", vin: "5YJ3MOCK", displayName: "Mock 3", state: .offline)]
        case .asleep, .parkedHomeAsleep:
            return [Vehicle(id: "1", vin: "5YJ3MOCK", displayName: "Mock 3", state: .asleep)]
        case .notConfigured:
            return []
        default:
            return [Vehicle(id: "1", vin: "5YJ3MOCK", displayName: "Mock 3", state: .online)]
        }
    }

    func vehicleData(id: String) async throws -> VehicleSnapshot {
        if scenario == .error { throw TeslaClientError.server(status: 503) }
        return snapshot(for: scenario)
    }

    func createTelemetryConfig(vin: String, workerURL: URL, sharedSecret: String) async throws {
        // No-op in mock.
    }

    func snapshot(for scenario: Scenario) -> VehicleSnapshot {
        let home = Self.home
        let away = Self.away
        let work = Self.work

        var base = VehicleSnapshot.placeholder()

        switch scenario {
        case .notConfigured:
            return base
        case .drivingHome:
            base.drive = DriveState(
                gear: .drive,
                speedKph: 92,
                headingDegrees: 280,
                coordinate: away,
                routeActive: true,
                routeDestination: home,
                routeDestinationName: "Home",
                routeMinutesToArrival: 14,
                routeEnergyAtArrivalKWh: 38
            )
        case .drivingElsewhere:
            base.drive = DriveState(
                gear: .drive,
                speedKph: 78,
                headingDegrees: 195,
                coordinate: away,
                routeActive: true,
                routeDestination: work,
                routeDestinationName: "Office",
                routeMinutesToArrival: 23,
                routeEnergyAtArrivalKWh: 42
            )
        case .parkedAllClosed:
            base.drive = DriveState(
                gear: .park,
                speedKph: 0,
                headingDegrees: nil,
                coordinate: work,
                routeActive: false,
                routeDestination: nil,
                routeDestinationName: nil,
                routeMinutesToArrival: nil,
                routeEnergyAtArrivalKWh: nil
            )
        case .parkedSomethingOpen:
            base.drive = DriveState(
                gear: .park,
                speedKph: 0,
                headingDegrees: nil,
                coordinate: work,
                routeActive: false,
                routeDestination: nil,
                routeDestinationName: nil,
                routeMinutesToArrival: nil,
                routeEnergyAtArrivalKWh: nil
            )
            base.doorsOpen = ["driver"]
            base.windowsOpen = ["driver"]
            base.trunkOpen = true
        case .parkedHomeAsleep:
            base.vehicle = Vehicle(id: base.vehicle.id, vin: base.vehicle.vin, displayName: base.vehicle.displayName, state: .asleep)
            base.drive = DriveState(
                gear: .park,
                speedKph: 0,
                headingDegrees: nil,
                coordinate: home,
                routeActive: false,
                routeDestination: nil,
                routeDestinationName: nil,
                routeMinutesToArrival: nil,
                routeEnergyAtArrivalKWh: nil
            )
        case .asleep:
            base.vehicle = Vehicle(id: base.vehicle.id, vin: base.vehicle.vin, displayName: base.vehicle.displayName, state: .asleep)
            base.drive.coordinate = away
        case .offline:
            base.vehicle = Vehicle(id: base.vehicle.id, vin: base.vehicle.vin, displayName: base.vehicle.displayName, state: .offline)
        case .error:
            return base
        }

        return base
    }
}
