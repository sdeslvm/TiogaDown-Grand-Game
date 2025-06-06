import Foundation
import SwiftUI

final class TiogaColor: UIColor {
    convenience init(rgb: String) {
        let clean = rgb.trimmingCharacters(in: .alphanumerics.inverted)
        var value: UInt64 = 0
        Scanner(string: clean).scanHexInt64(&value)
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
}

func launchTioga() -> some View {
    let tiogaViewModel = TiogaViewModel(url: URL(string: "https://tdowngrandgame.top/get")!)
    return TiogaScreen(viewModel: tiogaViewModel)
        .background(Color(TiogaColor(rgb: "#000000")))
}

struct TiogaEntry: View {
    var body: some View {
        launchTioga()
    }
}

#Preview {
    TiogaEntry()
}
