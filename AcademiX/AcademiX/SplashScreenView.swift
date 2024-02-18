import SwiftUI

struct SplashScreenView: View {
    @State private var isActive: Bool = false
    @State private var size: CGFloat = 0.8
    @State private var opacity: Double = 0.5
    @State private var rotation: Double = 0
    @State private var colorCycle: Double = 0.0
    @State private var backgroundColor = Color.white
    @State private var boxColor = Color.black // Box color will change based on background

    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                backgroundColor
                    .edgesIgnoringSafeArea(.all)
                    .onChange(of: backgroundColor) { newValue in
                        // Change box color based on background color for better visibility
                        boxColor = newValue == Color.black ? .white : .black
                    }
                
                VStack {
                    Image("AcademiXLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 400, height: 400)
                        .padding(.bottom, -100)
                        .padding(.top, -75)
                        .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))
                        .hueRotation(Angle(degrees: colorCycle))
                        .scaleEffect(size)
                    
                    // Text with a background box
                    Text("AcademiX")
                        .font(Font.custom("Menlo Regular", size: 40))
                        .foregroundColor(.black.opacity(opacity))
                        .padding() // Add padding around the text inside the box
                        .background(boxColor.cornerRadius(10)) // Box with rounded corners
                        .padding(.horizontal, 20) // Additional spacing around the box if needed
                }
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 2.5).repeatCount(5, autoreverses: true)) {
                        self.size = 1.1
                        self.opacity = 1.0
                        self.rotation = 360
                        self.colorCycle = 360
                    }
                    
                    withAnimation(Animation.easeInOut(duration: 2.5).repeatCount(5, autoreverses: true)) {
                        self.backgroundColor = Color.black // Start with black background
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + (2.5 * 10)) { // Adjust total duration to match your animation
                    self.isActive = true
                }
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
