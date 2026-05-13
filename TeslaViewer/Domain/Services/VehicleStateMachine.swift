import Foundation
import CoreLocation

struct VehicleStateMachine {
    let classifier: LocationClassifier

    init(home: CLLocationCoordinate2D?, homeRadiusMeters: CLLocationDistance = 75) {
        self.classifier = LocationClassifier(home: home, homeRadiusMeters: homeRadiusMeters)
    }

    init(classifier: LocationClassifier) {
        self.classifier = classifier
    }

    func reduce(snapshot: VehicleSnapshot?) -> MenuBarState {
        guard let snapshot else { return .notConfigured }

        switch snapshot.vehicle.state {
        case .offline:
            return .offline
        case .asleep:
            if classifier.isAtHome(snapshot.drive.coordinate) {
                return .parkedHomeAsleep
            }
            return .asleep
        case .unknown, .online:
            break
        }

        if snapshot.drive.gear == .drive || snapshot.drive.speedKph > 1 {
            let minutes = Int((snapshot.drive.routeMinutesToArrival ?? 0).rounded())
            let headingHome = classifier.destinationIsHome(snapshot.drive.routeDestination)
                || classifier.isHeadingHome(coordinate: snapshot.drive.coordinate, headingDegrees: snapshot.drive.headingDegrees)
            return headingHome ? .drivingHome(minutesToArrival: minutes) : .drivingElsewhere(minutesToArrival: minutes)
        }

        if snapshot.drive.gear == .park {
            if classifier.isAtHome(snapshot.drive.coordinate) && snapshot.vehicle.state == .asleep {
                return .parkedHomeAsleep
            }
            if snapshot.anyOpen {
                return .parkedSomethingOpen(count: snapshot.openCount)
            }
            return .parkedAllClosed
        }

        return .parkedAllClosed
    }
}
