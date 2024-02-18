import SwiftUI
import AVFoundation

struct SplashScreenView: View {
    @State private var isActive: Bool = false
    @State private var size: CGFloat = 0.8
    @State private var opacity: Double = 0.5
    @State private var rotation: Double = 0
    @State private var colorCycle: Double = 0.0
    @State private var backgroundColor = Color.white // Start with white background
    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                backgroundColor
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Image("AcademiXLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 400, height: 400)
                        .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))
                        .hueRotation(Angle(degrees: colorCycle))
                        .scaleEffect(size)
                        .padding(.bottom, -100)
                        .padding(.top, -75)

                    Text("AcademiX")
                        .font(Font.custom("Menlo Regular", size: 40))
                        .foregroundColor(.black.opacity(opacity))
                        .background(Color.white.cornerRadius(10)) // White box around the text for better readability
                        .padding(.horizontal, 20) // Horizontal padding for the box around the text
                }
                .onAppear {
                    playSound(soundName: "loading", volume: 0.2) // Reduced initial volume for more quiet sound
                    withAnimation(Animation.easeInOut(duration: 3)) {
                        self.size = 1.1
                        self.opacity = 1.0
                        self.rotation = 360
                        self.colorCycle = 360
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        withAnimation(Animation.easeOut(duration: 0.5)) {
                            self.isActive = true
                        }
                        fadeOutSound(duration: 2) // Fade out the sound smoothly over 2 seconds
                    }
                }
            }
        }
    }

    func playSound(soundName: String, volume: Float) {
        guard let path = Bundle.main.path(forResource: soundName, ofType: "mp3") else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.volume = volume // Set lower initial volume
            audioPlayer?.play()
        } catch {
            print("Unable to load the sound file.")
        }
    }

    func fadeOutSound(duration: TimeInterval) {
        guard let player = audioPlayer, player.volume > 0.0 else {
            return
        }

        let fadeOutSteps = 20
        let fadeOutStepDuration = duration / Double(fadeOutSteps)
        let volumeDecrement = player.volume / Float(fadeOutSteps)

        Timer.scheduledTimer(withTimeInterval: fadeOutStepDuration, repeats: true) { timer in
            if player.volume > 0.0 {
                player.volume -= volumeDecrement
            } else {
                player.stop()
                timer.invalidate()
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
