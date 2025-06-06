import Foundation

/// Состояние загрузки Tioga
enum TiogaState: Equatable {
    case idle
    case loading(Double)
    case completed
    case failed(Error)
    case offline

    static func == (lhs: TiogaState, rhs: TiogaState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.completed, .completed), (.offline, .offline):
            return true
        case (.loading(let l), .loading(let r)):
            return l == r
        case (.failed, .failed):
            return true
        default:
            return false
        }
    }
}

