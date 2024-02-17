//
//  SplashScreenView.swift
//  AcademiX
//
//  Created by Kirill Kheyfets on 2/17/24.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive: Bool = false
    @State private var size: CGFloat = 0.8
    @State private var opacity: Double = 0.0

    var body: some View {
        if isActive {
            ContentView()
        } else {
            VStack {
                VStack {
                    Image("AcademiXLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 400, height: 400)
                        .padding(.bottom, -100)
                        .padding(.top, -75)
                    Text("AcademiX")
                        .font(Font.custom("Menlo Regular", size: 40))
                        .foregroundColor(.black.opacity(0.80))
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 3.0).delay(1.0)) {
                        self.size = 1.2
                        self.opacity = 1.0
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    withAnimation {
                        self.isActive = true
                    }
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
