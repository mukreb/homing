import Foundation

protocol TeslaClient {
    func listVehicles() async throws -> [Vehicle]
    func vehicleData(id: String) async throws -> VehicleSnapshot
    func createTelemetryConfig(vin: String, workerURL: URL, sharedSecret: String) async throws
}

enum TeslaClientError: Error, Equatable {
    case notAuthenticated
    case notFound
    case rateLimited
    case server(status: Int)
    case decoding(String)
}
