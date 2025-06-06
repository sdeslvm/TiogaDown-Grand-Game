import SwiftUI

struct TiogaHotelLoadingView: View {
    let progress: Double

    var body: some View {
        ZStack {
            // Градиентный розовый фон
            LinearGradient(
                gradient: Gradient(colors: [Color.pink.opacity(0.9), Color.orange.opacity(0.5)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            // Пузырьки
            TiogaBubbleAnimationView()

            // Двери отеля
            TiogaHotelDoors(progress: progress)
                .frame(width: 220, height: 300)

            // Текст прогресса
            VStack {
                Spacer()
                Text("Tioga Hotel: Checking in... \(Int(progress * 100))%")
                    .font(.custom("SnellRoundhand-Bold", size: 28))
                    .foregroundColor(.pink)
                    .shadow(color: .white.opacity(0.7), radius: 6, x: 0, y: 2)
                    .padding(.bottom, 60)
            }
        }
    }
}

struct TiogaHotelDoors: View {
    let progress: Double

    var body: some View {
        ZStack {
            // Левая дверь
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.white.opacity(0.97))
                .frame(width: 100, height: 300)
                .offset(x: CGFloat(-progress) * 60)
                .shadow(radius: 8)
                .mask(
                    Rectangle().offset(x: -10)
                )
            // Правая дверь
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.white.opacity(0.97))
                .frame(width: 100, height: 300)
                .offset(x: CGFloat(progress) * 60)
                .shadow(radius: 8)
                .mask(
                    Rectangle().offset(x: 10)
                )
            // Свет за дверями
            if progress > 0.7 {
                Ellipse()
                    .fill(Color.yellow.opacity(0.3 + 0.4 * progress))
                    .frame(width: 120, height: 60)
                    .offset(y: 80)
                    .blur(radius: 10)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.7), value: progress)
    }
}

struct TiogaBubbleAnimationView: View {
    @State private var animate = false

    var body: some View {
        ZStack {
            ForEach(0..<12) { i in
                Circle()
                    .fill(Color.white.opacity(0.15 + Double.random(in: 0.1...0.2)))
                    .frame(width: CGFloat.random(in: 18...36), height: CGFloat.random(in: 18...36))
                    .offset(
                        x: CGFloat.random(in: -150...150),
                        y: animate ? CGFloat.random(in: 50...100) : CGFloat.random(in: 200...400)
                    )
                    .animation(
                        Animation.easeInOut(duration: Double.random(in: 2.5...4.5))
                            .repeatForever()
                            .delay(Double(i) * 0.2),
                        value: animate
                    )
            }
        }
        .onAppear { animate = true }
    }
}

#Preview {
    TiogaHotelLoadingView(progress: 0.6)
}
