import SwiftUI

@main
struct TeslaViewerApp: App {
    @StateObject private var viewModel: MenuBarLabelViewModel

    init() {
        let mock = MockTeslaClient(scenario: .parkedAllClosed)
        _viewModel = StateObject(wrappedValue: MenuBarLabelViewModel(client: mock, home: MockTeslaClient.home))
    }

    var body: some Scene {
        MenuBarExtra {
            DebugPickerView(viewModel: viewModel)
        } label: {
            MenuBarLabelView(state: viewModel.state)
        }
        .menuBarExtraStyle(.window)
    }
}
