

import SwiftUI


enum APIError2: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}

struct CreateView: View {
    @State private var adminName: String = ""
    @State private var className: String = ""
    @State private var classInfo: String = ""
    @State private var creationSuccess: Bool = false
    @State private var errorText: String?
    @State private var isPressed: Bool = false

    var body: some View {
        VStack {
            Text("Create a Class")
                .font(Font.custom("Menlo Regular", size: 30))
                .fontWeight(.bold)

            Image("AcademiXLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 400, height: 400)
                .padding(.bottom, -100)
                .padding(.top, -75)
                .shadow(color: .green, radius: 10, x: 0, y: 0)

            TextField("Admin Name (required)", text: $adminName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 3, x: 0, y: 3)
                .frame(width: 300)
                .font(Font.custom("Menlo Regular", size: 18))
                .padding([.leading, .trailing], 40)
                .padding([.top, .bottom], 5)

            TextField("Class Name (required)", text: $className)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 3, x: 0, y: 3)
                .frame(width: 300)
                .font(Font.custom("Menlo Regular", size: 18))
                .padding([.leading, .trailing], 40)
                .padding([.top, .bottom], 5)

            TextField("Class Information", text: $classInfo)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 3, x: 0, y: 3)
                .frame(width: 300, height: 100)
                .font(Font.custom("Menlo Regular", size: 18))
                .padding([.leading, .trailing], 40)
                .padding([.top, .bottom], 5)

            Button("Submit") {
                Task {
                    await createClass()
                }
            }
            .padding(10)
            .font(Font.custom("Menlo Regular", size: 18))
            .background(adminName.isEmpty || className.isEmpty ? Color.gray : Color.black)
            .foregroundColor(.white)
            .cornerRadius(5)
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.easeInOut, value: isPressed)
            .onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity, pressing: { pressing in
                self.isPressed = pressing
            }, perform: {})
            .disabled(adminName.isEmpty || className.isEmpty)

            if creationSuccess {
                Text("Class created successfully!")
                    .foregroundColor(.green)
            }

            if let errorText = errorText {
                Text(errorText)
                    .foregroundColor(.red)
            }
        }
        .environment(\.colorScheme, .light)
    }

    func createClass() async {
        let classDetails = ClassCreationRequest(name: className, info: classInfo, admin_username: adminName)
        
        do {
            let createdClass = try await postClass(classDetails: classDetails)
            DispatchQueue.main.async {
                self.creationSuccess = true
                self.errorText = nil
                // Save to UserDefaults
                saveCreatedClassData(classId: createdClass.id, adminName: adminName)
            }
        } catch {
            DispatchQueue.main.async {
                self.creationSuccess = false
                self.errorText = "Failed to create class. Please try again."
            }
        }
    }
    
    func saveCreatedClassData(classId: String, adminName: String) {
        var joinedClassIDs = UserDefaults.standard.array(forKey: "joinedClassIDs") as? [String] ?? []
        joinedClassIDs.append(classId)
        UserDefaults.standard.set(joinedClassIDs, forKey: "joinedClassIDs")
        UserDefaults.standard.set(adminName, forKey: "classmateName")
    }
}

func postClass(classDetails: ClassCreationRequest) async throws -> ClassCreatedResponse {
    let endpoint = "http://217.25.90.34:8500/api/classes"
    guard let url = URL(string: endpoint) else {
        throw APIError2.invalidURL
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    let encoder = JSONEncoder()
    let jsonData = try encoder.encode(classDetails)
    request.httpBody = jsonData
    
    let (data, response) = try await URLSession.shared.data(for: request)
    guard let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode == 201 else {
        throw APIError2.invalidResponse
    }
    
    let createdClass = try JSONDecoder().decode(ClassCreatedResponse.self, from: data)
    return createdClass
}

struct ClassCreationRequest: Codable {
    let name: String
    let info: String?
    let admin_username: String
}

struct ClassCreatedResponse: Codable {
    let id: String
    let name: String
    let info: String?
    let admin_username: String
    let sunday: String?
    let monday: String?
    let tuesday: String?
    let wednesday: String?
    let thursday: String?
    let friday: String?
    let saturday: String?
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView()
    }
}
