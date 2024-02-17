//
//  CreateView.swift
//  AcademiX
//
//  Created by Olti Gjoni on 2/16/24.
//

import SwiftUI

struct CreateView: View {
    @State private var adminName: String = ""
    @State private var className: String = ""
    @State private var classInfo: String = ""
    @State private var isClassCodeViewPresented: Bool = false
    @State private var isPressed = false


    var body: some View {
        VStack {
            // Title Heading
            Text("Create a Class")
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
            TextField("Admin Name (required)", text: $adminName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(Color.white) // Background color of the TextField
                .cornerRadius(10) // Rounded corners
                .shadow(color: .gray, radius: 3, x: 0, y: 3) // Shadow effect
                .frame(width: 300)
                .font(Font.custom("Menlo Regular", size: 18))
                .padding([.leading, .trailing], 40)
                .padding([.top, .bottom], 5)
            TextField("Class Name (required)", text: $className)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(Color.white) // Background color of the TextField
                .cornerRadius(10) // Rounded corners
                .shadow(color: .gray, radius: 3, x: 0, y: 3) // Shadow effect
                .frame(width: 300)
                .font(Font.custom("Menlo Regular", size: 18))
                .padding([.leading, .trailing], 40)
                .padding([.top, .bottom], 5)
            TextField("Class Information", text: $classInfo)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(Color.white) // Background color of the TextField
                .cornerRadius(10) // Rounded corners
                .shadow(color: .gray, radius: 3, x: 0, y: 3) // Shadow effect
                .frame(width: 300, height: 30)
                .font(Font.custom("Menlo Regular", size: 18))
                .padding([.leading, .trailing], 40)
                .padding([.top, .bottom], 5)

            // Submit Button
            Button("Submit") {
                self.isClassCodeViewPresented = true
            }
            .padding(10)
            .font(Font.custom("Menlo Regular", size: 18))
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(5)
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.easeInOut, value: isPressed)
            .onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity, pressing: { pressing in
                self.isPressed = pressing
            }, perform: {})
            
            .disabled(adminName.isEmpty)
            .disabled(className.isEmpty)


        }
        // This line enforces light mode for this view
        .environment(\.colorScheme, .light)
        
        
    }
}

struct CreateClassCodeView: View {
    @Binding var classCode: String

    var body: some View {
        ZStack{
            Image("AcademiXLogo")
                .resizable()
                .scaledToFill()
                .opacity(0.1) // Adjust the opacity to make the logo more or less transparent
//                .edgesIgnoringSafeArea(.all) // Make the image extend to the edges of the view
            VStack {
                TextField("Class Code", text: $classCode)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(10)
                    .font(Font.custom("Menlo Regular", size: 18))
                    .background(Color.black)
                    .cornerRadius(5)
                    .frame(width: 150)


                Button("Submit") {
                    // Handle the submission of the class code
                }
                .padding(10)
                .font(Font.custom("Menlo Regular", size: 18))
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(5)
            }
        }
        
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView()
            // This line enforces light mode for the preview
            .environment(\.colorScheme, .light)
    }
}