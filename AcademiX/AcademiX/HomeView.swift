//
//  HomeView.swift
//  AcademiX
//
//  Created by Olti Gjoni on 2/16/24.
//

import SwiftUI

struct HomeView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var classCode: String = ""
    @State private var isClassCodeViewPresented: Bool = false
    @State private var isPressed = false


    var body: some View {
        VStack {
            // Title Heading
            Text("Welcome to AcademiX")
                .font(Font.custom("Menlo Regular", size: 30))
                .fontWeight(.bold)
            // Logo
            Image("AcademiXLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 400, height: 400)
                .padding(.bottom, -100)
                .padding(.top, -75)
                .shadow(color: .black, radius: 10, x: 0, y: 0) // Shadow effect

            // First Name TextField
            TextField("First Name", text: $firstName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(Color.white) // Background color of the TextField
                .cornerRadius(10) // Rounded corners
                .shadow(color: .gray, radius: 3, x: 0, y: 3) // Shadow effect
                .frame(width: 150)
                .font(Font.custom("Menlo Regular", size: 18))
                .padding([.leading, .trailing], 40)
                .padding([.top, .bottom], 5)

            // Last Name TextField
            TextField("Last Name", text: $lastName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(Color.white) // Background color of the TextField
                .cornerRadius(10) // Rounded corners
                .shadow(color: .gray, radius: 3, x: 0, y: 3) // Shadow effect
                .frame(width: 150)
                .font(Font.custom("Menlo Regular", size: 18))
                .padding([.leading, .trailing], 40)
                .padding([.top, .bottom], 20)

            // Submit Button
            Button("Submit") {
                self.isClassCodeViewPresented = true
            }
            .padding(10)
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(5)
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.easeInOut, value: isPressed)
            .onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity, pressing: { pressing in
                self.isPressed = pressing
            }, perform: {})
            
            .disabled(firstName.isEmpty || lastName.isEmpty)
            .sheet(isPresented: $isClassCodeViewPresented) {
                ClassCodeView(classCode: $classCode)
            }
        }
        // This line enforces light mode for this view
        .environment(\.colorScheme, .light)
    }
}

struct ClassCodeView: View {
    @Binding var classCode: String

    var body: some View {
        VStack {
            TextField("Class Code", text: $classCode)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Submit") {
                // Handle the submission of the class code
            }
            .padding()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            // This line enforces light mode for the preview
            .environment(\.colorScheme, .light)
    }
}
