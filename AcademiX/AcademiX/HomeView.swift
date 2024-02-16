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

    var body: some View {
        VStack {
            // Title Heading
            Text("Welcome to AcademiX")
                .font(.largeTitle)
                .fontWeight(.bold)
            // Logo
            Image("AcademiXLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 400, height: 400)
            
  
            
//            Spacer() // Pushes the content to the top
            
            TextField("First Name", text: $firstName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Last Name", text: $lastName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Submit") {
                // This is where you would typically validate the first name and last name
                // and potentially prepare to navigate to the next view.
                // For simplicity, we'll just set isClassCodeViewPresented to true.
                self.isClassCodeViewPresented = true
            }
            .disabled(firstName.isEmpty || lastName.isEmpty)
            .padding()
            .sheet(isPresented: $isClassCodeViewPresented) {
                ClassCodeView(classCode: $classCode)
            }
        }
    }
}

struct ClassCodeView: View {
    @Binding var classCode: String

    var body: some View {
        VStack {
            TextField("Class Code", text: $classCode)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // You could add a button here to "submit" the class code.
            Button("Submit") {
                // This is where you would typically validate the first name and last name
                // and potentially prepare to navigate to the next view.
                // For simplicity, we'll just set isClassCodeViewPresented to true.
            }
            // For example, a button that does something with the class code
            // like checking it against a database or adding the user to a class.
        }
        .padding()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
