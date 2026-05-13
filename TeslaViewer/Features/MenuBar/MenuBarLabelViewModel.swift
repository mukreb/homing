import Foundation
import SwiftUI
import CoreLocation
import Combine

@MainActor
final class MenuBarLabelViewModel: ObservableObject {
    @Published private(set) var state: MenuBarState = .notConfigured
    @Published private(set) var snapshot: VehicleSnapshot?

    private let client: TeslaClient
    private var stateMachine: VehicleStateMachine

    init(client: TeslaClient, home: CLLocationCoordinate2D? = nil) {
        self.client = client
        self.stateMachine = VehicleStateMachine(home: home)
    }

    func setHome(_ home: CLLocationCoordinate2D?) {
        stateMachine = VehicleStateMachine(home: home)
        recompute()
    }

    func apply(_ snapshot: VehicleSnapshot?) {
        self.snapshot = snapshot
        recompute()
    }

    func loadFromMock(scenario: MockTeslaClient.Scenario) async {
        guard let mock = client as? MockTeslaClient else { return }
        mock.scenario = scenario
        if scenario == .notConfigured {
            apply(nil)
            return
        }
        apply(mock.snapshot(for: scenario))
    }

    private func recompute() {
        state = stateMachine.reduce(snapshot: snapshot)
    }
}
