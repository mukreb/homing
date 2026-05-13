import XCTest
import CoreLocation
@testable import TeslaViewer

@MainActor
final class MenuBarLabelViewModelTests: XCTestCase {
    func test_errorScenarioReachesErrorState() async {
        let mock = MockTeslaClient(scenario: .parkedAllClosed)
        let vm = MenuBarLabelViewModel(client: mock, home: MockTeslaClient.home)
        await vm.loadFromMock(scenario: .error)
        guard case .error = vm.state else {
            XCTFail("Expected .error, got \(vm.state)")
            return
        }
    }

    func test_drivingHomeScenarioRendersDrivingHome() async {
        let mock = MockTeslaClient(scenario: .parkedAllClosed)
        let vm = MenuBarLabelViewModel(client: mock, home: MockTeslaClient.home)
        await vm.loadFromMock(scenario: .drivingHome)
        XCTAssertEqual(vm.state, .drivingHome(minutesToArrival: 14))
    }

    func test_parkedHomeAsleepScenarioRendersParkedHomeAsleep() async {
        let mock = MockTeslaClient(scenario: .parkedAllClosed)
        let vm = MenuBarLabelViewModel(client: mock, home: MockTeslaClient.home)
        await vm.loadFromMock(scenario: .parkedHomeAsleep)
        XCTAssertEqual(vm.state, .parkedHomeAsleep)
    }

    func test_notConfiguredScenarioRendersNotConfigured() async {
        let mock = MockTeslaClient(scenario: .parkedAllClosed)
        let vm = MenuBarLabelViewModel(client: mock, home: MockTeslaClient.home)
        await vm.loadFromMock(scenario: .notConfigured)
        XCTAssertEqual(vm.state, .notConfigured)
    }
}
