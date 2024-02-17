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
                .font(Font.custom("Menlo Regular", size: 30))

                .fontWeight(.bold)
            // Logo
            Image("AcademiXLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 400, height: 400)
                .padding(.bottom, -100)
                .padding(.top, -75)
                .shadow(color: .black, radius: 40, x: 0, y: 0) // Shadow effect
            
            
  
    
            TextField("First Name", text: $firstName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(Color.white) // Background color of the TextField
                .cornerRadius(10) // Rounded corners
                .shadow(color: .gray, radius: 5, x: 0, y: 3) // Shadow effect
                .frame(width: 150)
                .font(Font.custom("Menlo Regular", size: 18))
                .padding([.leading, .trailing], 40)
                .padding([.top, .bottom], 5)

            

            
            TextField("Last Name", text: $lastName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(Color.white) // Background color of the TextField
                .cornerRadius(10) // Rounded corners
                .shadow(color: .gray, radius: 5, x: 0, y: 3) // Shadow effect
                .frame(width: 150)
                .font(Font.custom("Menlo Regular", size: 18))
                .padding([.leading, .trailing], 40)
                .padding([.top, .bottom], 5)

            
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
