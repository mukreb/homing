import XCTest
import CoreLocation
@testable import Homing

final class LocationClassifierTests: XCTestCase {
    let home = CLLocationCoordinate2D(latitude: 52.3676, longitude: 4.9041)

    func test_isAtHomeWithinRadius() {
        let nearby = CLLocationCoordinate2D(latitude: 52.36761, longitude: 4.90411)
        let c = LocationClassifier(home: home)
        XCTAssertTrue(c.isAtHome(nearby))
    }

    func test_isAtHomeOutsideRadius() {
        let far = CLLocationCoordinate2D(latitude: 52.4000, longitude: 4.9041)
        let c = LocationClassifier(home: home)
        XCTAssertFalse(c.isAtHome(far))
    }

    func test_bearingNorthIsZero() {
        let north = CLLocationCoordinate2D(latitude: home.latitude + 0.1, longitude: home.longitude)
        let c = LocationClassifier(home: home)
        let bearing = c.bearing(from: home, to: north)
        XCTAssertEqual(bearing, 0, accuracy: 0.5)
    }

    func test_bearingEastIsNinety() {
        let east = CLLocationCoordinate2D(latitude: home.latitude, longitude: home.longitude + 0.1)
        let c = LocationClassifier(home: home)
        let bearing = c.bearing(from: home, to: east)
        XCTAssertEqual(bearing, 90, accuracy: 0.5)
    }

    func test_angularDifferenceWrapsAround() {
        let c = LocationClassifier(home: home)
        XCTAssertEqual(c.angularDifference(10, 350), 20, accuracy: 0.0001)
        XCTAssertEqual(c.angularDifference(355, 5), 10, accuracy: 0.0001)
    }

    func test_isHeadingHomeWithinTolerance() {
        let far = CLLocationCoordinate2D(latitude: home.latitude - 0.5, longitude: home.longitude)
        let c = LocationClassifier(home: home)
        XCTAssertTrue(c.isHeadingHome(coordinate: far, headingDegrees: 0))
        XCTAssertFalse(c.isHeadingHome(coordinate: far, headingDegrees: 180))
    }
}
