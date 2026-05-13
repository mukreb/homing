import Foundation

struct ClimateState: Equatable, Codable {
    var insideTempC: Double?
    var outsideTempC: Double?
    var climateOn: Bool

    static let unknown = ClimateState(insideTempC: nil, outsideTempC: nil, climateOn: false)
}
