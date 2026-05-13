import SwiftUI

struct DebugPickerView: View {
    @ObservedObject var viewModel: MenuBarLabelViewModel
    @State private var scenario: MockTeslaClient.Scenario = .parkedAllClosed

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Debug")
                .font(.headline)
            Picker("Scenario", selection: $scenario) {
                ForEach(MockTeslaClient.Scenario.allCases) { s in
                    Text(s.rawValue).tag(s)
                }
            }
            .pickerStyle(.menu)
            .onChange(of: scenario) { _, new in
                Task { await viewModel.loadFromMock(scenario: new) }
            }
            HStack {
                Text("Current state:")
                Text(String(describing: viewModel.state))
                    .foregroundStyle(.secondary)
            }
            .font(.callout)
        }
        .padding()
        .frame(width: 320, alignment: .leading)
    }
}
