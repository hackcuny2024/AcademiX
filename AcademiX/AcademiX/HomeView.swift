//
//  HomeView.swift
//  AcademiX
//
//  Created by Olti Gjoni on 2/16/24.
//

import SwiftUI

struct HomeView: View {
    @State private var name: String = ""
    @State private var classCode: String = ""
    @State private var isPressed = false
    @State private var showingAlert = false
    @State private var alertMessage = ""

    var body: some View {
        VStack {
            Text("Join a Class")
                .font(Font.custom("Menlo Regular", size: 30))
                .fontWeight(.bold)

            Image("AcademiXLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 400, height: 400)
                .padding(.bottom, -100)
                .padding(.top, -75)
                .shadow(color: .blue, radius: 10, x: 0, y: 0)

            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 3, x: 0, y: 3)
                .frame(width: 300)
                .font(Font.custom("Menlo Regular", size: 18))
                .padding([.leading, .trailing], 40)
                .padding([.top, .bottom], 5)

            TextField("Class ID", text: $classCode)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 3, x: 0, y: 3)
                .frame(width: 300)
                .font(Font.custom("Menlo Regular", size: 18))
                .padding([.leading, .trailing], 40)
                .padding([.top, .bottom], 5)

            Button("Submit") {
                joinClass(name: name, classId: classCode)
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
            .disabled(name.isEmpty || classCode.isEmpty)
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Join Class"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .environment(\.colorScheme, .light)
    }

    func joinClass(name: String, classId: String) {
        guard let url = URL(string: "http://217.25.90.34:8500/api/classes/join") else {
            self.alertMessage = "Invalid URL"
            self.showingAlert = true
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["name": name, "class_id": classId]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.alertMessage = "Error joining class: \(error.localizedDescription)"
                    self.showingAlert = true
                }
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data {
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let newClass = jsonObject["new_class"] as? [String: Any],
                       let id = newClass["id"] as? String {
                        saveClassData(id: id, classId: classId, name: name)
                        DispatchQueue.main.async {
                            self.alertMessage = "Successfully joined the class and saved data!"
                            self.showingAlert = true
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.alertMessage = "Failed to parse response."
                            self.showingAlert = true
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.alertMessage = "Failed to join the class: \(error.localizedDescription)"
                        self.showingAlert = true
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.alertMessage = "Failed to join the class."
                    self.showingAlert = true
                }
            }
        }.resume()
    }
    
    func saveClassData(id: String, classId: String, name: String) {
        // Retrieve the current array of joined class IDs or initialize a new one
        var joinedClassIDs = UserDefaults.standard.array(forKey: "joinedClassIDs") as? [String] ?? []
        
        // Append the new class ID
        joinedClassIDs.append(classId)
        
        // Save the updated array back to UserDefaults
        UserDefaults.standard.set(joinedClassIDs, forKey: "joinedClassIDs")
        
        // Save other classmate information
        UserDefaults.standard.set(id, forKey: "classmateId")
        UserDefaults.standard.set(name, forKey: "classmateName")
    }

}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

























//
//struct ClassCodeView: View {
//    @Binding var classCode: String
//
//    var body: some View {
//        ZStack{
//            Image("AcademiXLogo")
//                .resizable()
//                .scaledToFill()
//                .opacity(0.1) // Adjust the opacity to make the logo more or less transparent
//                .edgesIgnoringSafeArea(.all) // Make the image extend to the edges of the view
//            VStack {
//                TextField("Class Code", text: $classCode)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding(10)
//                    .font(Font.custom("Menlo Regular", size: 18))
//                    .background(Color.black)
//                    .cornerRadius(5)
//                    .frame(width: 150)
//
//
//                Button("Submit") {
//                    // Handle the submission of the class code
//                }
//                .padding(10)
//                .font(Font.custom("Menlo Regular", size: 18))
//                .background(Color.black)
//                .foregroundColor(.white)
//                .cornerRadius(5)
//            }
//        }
//
//    }
//}
