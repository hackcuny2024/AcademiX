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
                .shadow(color: .black, radius: 10, x: 0, y: 0)

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
                .frame(width: 300, height: 30)
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
            let _ = try await postClass(classDetails: classDetails)
            creationSuccess = true
            errorText = nil
        } catch {
            creationSuccess = false
            errorText = "Failed to create class. Please try again."
        }
    }
}

func postClass(classDetails: ClassCreationRequest) async throws -> Bool {
    let endpoint = "http://217.25.90.34:8500/api/classes"
    guard let url = URL(string: endpoint) else {
        throw APIError2.invalidURL
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    let encoder = JSONEncoder()
    do {
        let jsonData = try encoder.encode(classDetails)
        request.httpBody = jsonData
        print("Request URL: \(url)")
        print("Request Body: \(String(data: jsonData, encoding: .utf8) ?? "")")
    } catch {
        print("Encoding Error: \(error)")
        throw APIError2.invalidData
    }
    
    do {
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError2.invalidResponse
        }
        
        print("Status Code: \(httpResponse.statusCode)")
        if let responseBody = String(data: data, encoding: .utf8) {
            print("Response Body: \(responseBody)")
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError2.invalidResponse
        }
        
        return true
    } catch {
        print("Networking Error: \(error)")
        throw error
    }
}

struct ClassCreationRequest: Codable {
    let name: String
    let info: String?
    let admin_username: String // Use snake_case as expected by the server

    // Specify the mapping between the property names and the keys used in the JSON body of the request
    enum CodingKeys: String, CodingKey {
        case name, info
        case admin_username = "admin_username"
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView()
        // This line enforces light mode for the preview
        .environment(\.colorScheme, .light)
    }
}

