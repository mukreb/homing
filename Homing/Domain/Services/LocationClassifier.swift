import Foundation
import CoreLocation

struct LocationClassifier {
    let home: CLLocationCoordinate2D?
    let homeRadiusMeters: CLLocationDistance

    init(home: CLLocationCoordinate2D?, homeRadiusMeters: CLLocationDistance = 75) {
        self.home = home
        self.homeRadiusMeters = homeRadiusMeters
    }

    func isAtHome(_ coordinate: CLLocationCoordinate2D?) -> Bool {
        guard let home, let coordinate else { return false }
        return distance(from: coordinate, to: home) <= homeRadiusMeters
    }

    func isHeadingHome(coordinate: CLLocationCoordinate2D?, headingDegrees: Double?) -> Bool {
        guard let home, let coordinate, let headingDegrees else { return false }
        let bearing = bearing(from: coordinate, to: home)
        return angularDifference(headingDegrees, bearing) <= 35
    }

    func destinationIsHome(_ destination: CLLocationCoordinate2D?) -> Bool {
        guard let home, let destination else { return false }
        return distance(from: destination, to: home) <= homeRadiusMeters
    }

    func distance(from a: CLLocationCoordinate2D, to b: CLLocationCoordinate2D) -> CLLocationDistance {
        let locA = CLLocation(latitude: a.latitude, longitude: a.longitude)
        let locB = CLLocation(latitude: b.latitude, longitude: b.longitude)
        return locA.distance(from: locB)
    }

    func bearing(from a: CLLocationCoordinate2D, to b: CLLocationCoordinate2D) -> Double {
        let lat1 = a.latitude * .pi / 180
        let lat2 = b.latitude * .pi / 180
        let dLon = (b.longitude - a.longitude) * .pi / 180

        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radians = atan2(y, x)
        let degrees = radians * 180 / .pi
        return (degrees + 360).truncatingRemainder(dividingBy: 360)
    }

    func angularDifference(_ a: Double, _ b: Double) -> Double {
        let diff = abs(a - b).truncatingRemainder(dividingBy: 360)
        return min(diff, 360 - diff)
    }
}
