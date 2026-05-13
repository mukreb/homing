import XCTest
import CoreLocation
@testable import Homing

final class VehicleStateMachineTests: XCTestCase {
    let home = CLLocationCoordinate2D(latitude: 52.3676, longitude: 4.9041)
    let away = CLLocationCoordinate2D(latitude: 52.0907, longitude: 5.1214)

    func test_noSnapshotReturnsNotConfigured() {
        let sm = VehicleStateMachine(home: home)
        XCTAssertEqual(sm.reduce(snapshot: nil), .notConfigured)
    }

    func test_offlineVehicleReturnsOffline() {
        let sm = VehicleStateMachine(home: home)
        var snap = VehicleSnapshot.placeholder()
        snap.vehicle = Vehicle(id: "1", vin: "v", displayName: "n", state: .offline)
        XCTAssertEqual(sm.reduce(snapshot: snap), .offline)
    }

    func test_asleepAtHomeReturnsParkedHomeAsleep() {
        let sm = VehicleStateMachine(home: home)
        var snap = VehicleSnapshot.placeholder()
        snap.vehicle = Vehicle(id: "1", vin: "v", displayName: "n", state: .asleep)
        snap.drive.coordinate = home
        XCTAssertEqual(sm.reduce(snapshot: snap), .parkedHomeAsleep)
    }

    func test_asleepAwayReturnsAsleep() {
        let sm = VehicleStateMachine(home: home)
        var snap = VehicleSnapshot.placeholder()
        snap.vehicle = Vehicle(id: "1", vin: "v", displayName: "n", state: .asleep)
        snap.drive.coordinate = away
        XCTAssertEqual(sm.reduce(snapshot: snap), .asleep)
    }

    func test_drivingTowardsHomeReturnsDrivingHome() {
        let sm = VehicleStateMachine(home: home)
        var snap = VehicleSnapshot.placeholder()
        snap.drive = DriveState(
            gear: .drive, speedKph: 90, headingDegrees: 280,
            coordinate: away, routeActive: true,
            routeDestination: home, routeDestinationName: "Home",
            routeMinutesToArrival: 14, routeEnergyAtArrivalKWh: 30
        )
        XCTAssertEqual(sm.reduce(snapshot: snap), .drivingHome(minutesToArrival: 14))
    }

    func test_drivingElsewhereReturnsDrivingElsewhere() {
        let sm = VehicleStateMachine(home: home)
        var snap = VehicleSnapshot.placeholder()
        let work = CLLocationCoordinate2D(latitude: 51.9244, longitude: 4.4777)
        snap.drive = DriveState(
            gear: .drive, speedKph: 80, headingDegrees: 195,
            coordinate: away, routeActive: true,
            routeDestination: work, routeDestinationName: "Work",
            routeMinutesToArrival: 23, routeEnergyAtArrivalKWh: 40
        )
        XCTAssertEqual(sm.reduce(snapshot: snap), .drivingElsewhere(minutesToArrival: 23))
    }

    func test_parkedAllClosed() {
        let sm = VehicleStateMachine(home: home)
        var snap = VehicleSnapshot.placeholder()
        snap.drive.gear = .park
        XCTAssertEqual(sm.reduce(snapshot: snap), .parkedAllClosed)
    }

    func test_parkedSomethingOpenCountsAllOpenItems() {
        let sm = VehicleStateMachine(home: home)
        var snap = VehicleSnapshot.placeholder()
        snap.drive.gear = .park
        snap.doorsOpen = ["driver"]
        snap.windowsOpen = ["driver"]
        snap.trunkOpen = true
        XCTAssertEqual(sm.reduce(snapshot: snap), .parkedSomethingOpen(count: 3))
    }
}
