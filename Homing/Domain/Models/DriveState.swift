import Foundation
import CoreLocation

struct DriveState: Equatable, Codable {
    enum Gear: String, Codable, Equatable {
        case park = "P"
        case reverse = "R"
        case neutral = "N"
        case drive = "D"
        case unknown
    }

    var gear: Gear
    var speedKph: Double
    var headingDegrees: Double?
    var coordinate: CLLocationCoordinate2D?
    var routeActive: Bool
    var routeDestination: CLLocationCoordinate2D?
    var routeDestinationName: String?
    var routeMinutesToArrival: Double?
    var routeEnergyAtArrivalKWh: Double?

    static let unknown = DriveState(
        gear: .unknown,
        speedKph: 0,
        headingDegrees: nil,
        coordinate: nil,
        routeActive: false,
        routeDestination: nil,
        routeDestinationName: nil,
        routeMinutesToArrival: nil,
        routeEnergyAtArrivalKWh: nil
    )
}

extension CLLocationCoordinate2D: @retroactive Decodable, @retroactive Encodable, @retroactive Equatable {
    enum CodingKeys: String, CodingKey { case latitude, longitude }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        self.init(
            latitude: try c.decode(Double.self, forKey: .latitude),
            longitude: try c.decode(Double.self, forKey: .longitude)
        )
    }

    public func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(latitude, forKey: .latitude)
        try c.encode(longitude, forKey: .longitude)
    }

    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
