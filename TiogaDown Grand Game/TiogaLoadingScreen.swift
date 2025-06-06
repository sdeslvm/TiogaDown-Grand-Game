import SwiftUI

struct TiogaScreen: View {
    @StateObject var viewModel: TiogaViewModel

    init(viewModel: TiogaViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            TiogaWebStage(viewModel: viewModel)
                .opacity(viewModel.tiogaStatus == .completed ? 1 : 0)
            TiogaOverlay(state: viewModel.tiogaStatus)
        }
    }
}

private struct TiogaOverlay: View {
    let state: TiogaState

    var body: some View {
        switch state {
        case .loading(let progress):
            TiogaHotelLoadingView(progress: progress)
        case .failed(let error):
            Text("Error: \(error.localizedDescription)").foregroundColor(.pink)
        case .offline:
            Text("Offline").foregroundColor(.gray)
        default:
            EmptyView()
        }
    }
}
