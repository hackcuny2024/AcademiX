import SwiftUI

struct Course: Identifiable, Decodable {
    let id: String
    let name: String
}

struct RandomColorOverlayModifier: ViewModifier {
    func body(content: Content) -> some View {
        // Combine the content with a randomly colored overlay
        content
            .overlay(
                Rectangle()
                    .fill(Color.random.opacity(0.1)) // Change opacity as needed
                    .blendMode(.overlay) // You can experiment with blend modes
            )
    }
}

extension View {
    func randomColorOverlay() -> some View {
        self.modifier(RandomColorOverlayModifier())
    }
}

extension Color {
    static var random: Color {
        Color(
            red: .random(in: 0...0.7),
            green: .random(in: 0...0.7),
            blue: .random(in: 0...0.7)
        )
    }
}

struct CourseView: View {
    @State private var showingHomeView = false
    @State private var showingCreateView = false
    @State private var courses: [Course] = []
    @State private var backgroundImageName = "Background"
    
    var body: some View {
        NavigationView {
            List(courses) { course in
                NavigationLink(destination: ChatView()) {
                    CourseRow(courseName: course.name)
                }
                .listRowBackground(
                                    ZStack {
                                        Color.random.opacity(0.5) // Apply random color with opacity
                                        Image(backgroundImageName)
                                            .resizable()
                                            .scaledToFill()
                                            .opacity(0.1)
                                    }
                                )
                Divider() // Add a divider after each course row
                    .background(Color.black) // Set the color of the divider
            }
            
            .navigationTitle("My Courses")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingHomeView = true
                    }) {
                        HStack {
                            Image(systemName: "person.fill.badge.plus")
                            Text("Join")
                                .font(Font.custom("Menlo Regular", size: 16))
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showingCreateView = true
                    }) {
                        HStack {
                            Image(systemName: "plus")
                            Text("Create")
                                .font(Font.custom("Menlo Regular", size: 16))
                        }
                    }
                }
                
            }
            
            .sheet(isPresented: $showingHomeView) {
                HomeView()
            }
            .sheet(isPresented: $showingCreateView) {
                CreateView()
            }
            .onAppear {
                fetchCourses()
            }
        }
    }
    
    func fetchCourses() {
        guard let savedClassIDs = UserDefaults.standard.array(forKey: "joinedClassIDs") as? [String], !savedClassIDs.isEmpty else {
            print("No saved class IDs")
            return
        }
        
        var fetchedCourses: [Course] = []
        let group = DispatchGroup()

        for courseID in savedClassIDs {
            guard let url = URL(string: "http://217.25.90.34:8500/api/classes/\(courseID)") else {
                print("Invalid URL for course ID: \(courseID)")
                continue
            }

            group.enter()
            URLSession.shared.dataTask(with: url) { data, response, error in
                defer { group.leave() }

                if let data = data, let decodedResponse = try? JSONDecoder().decode(Course.self, from: data) {
                    DispatchQueue.main.async {
                        fetchedCourses.append(decodedResponse)
                    }
                } else {
                    print("Fetch failed for course ID: \(courseID), error: \(error?.localizedDescription ?? "Unknown error")")
                }
            }.resume()
        }

        group.notify(queue: .main) {
            self.courses = fetchedCourses.sorted(by: { $0.name < $1.name })
        }
    }
}

struct CourseRow: View {
    var courseName: String

    var body: some View {
        HStack {
            Image(systemName: "book.closed")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 30)
                .padding(15)
                .padding(.trailing, 10)

            Text(courseName)
                .font(Font.custom("Menlo Regular", size: 17))
                .padding(6)
                .background(Color.white) // Set the background color to white
                .cornerRadius(10) // Optionally, add a corner radius to smooth the edges
        
            Spacer()
    
        }
        .padding(.vertical, 8) // Add padding to top and bottom of the row content
    }
}

struct CourseView_Previews: PreviewProvider {
    static var previews: some View {
        CourseView()
    }
}
