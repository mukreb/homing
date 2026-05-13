import Foundation

struct Vehicle: Equatable, Codable, Identifiable {
    let id: String
    let vin: String
    let displayName: String
    let state: OnlineState

    enum OnlineState: String, Codable, Equatable {
        case online
        case asleep
        case offline
        case unknown
    }
}
