import SwiftUI

struct Course: Identifiable, Decodable {
    let id: String
    let name: String
}

struct CourseView: View {
    @State private var showingHomeView = false
    @State private var showingCreateView = false
    @State private var courses: [Course] = []
    
    var body: some View {
        NavigationView {
            List(courses) { course in
                NavigationLink(destination: ChatView()) {
                    CourseRow(courseName: course.name)
                }
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
        let courseIDs = ["527f0a01-1f83-40cb-8929-fcb5d47b5438"]
        var fetchedCourses: [Course] = []

        let group = DispatchGroup()

        for courseID in courseIDs {
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
                .font(.title3)

            Spacer()
        }
    }
}

struct CourseView_Previews: PreviewProvider {
    static var previews: some View {
        CourseView()
    }
}
