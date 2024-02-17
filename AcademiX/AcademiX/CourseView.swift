import SwiftUI

// The main view displaying a list of courses
struct CourseView: View {
    @State private var showingHomeView = false
    @State private var showingCreateView = false
    let courses = ["Computer Science 101", "Philosophy 202", "Mathematics 303"]

    var body: some View {
        NavigationView {
            List(courses, id: \.self) { course in
                NavigationLink(destination: Text("Details for \(course)")) {
                    CourseRow(courseName: course)
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
                HomeView() // Present the HomeView when "Join" is tapped
            }
            .sheet(isPresented: $showingCreateView) {
                CreateView() // Present the CreateView when "Create" is tapped
            }
        }
    }
}

// Define a view for each row in the list
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

// Preview provider for SwiftUI previews
struct CourseView_Previews: PreviewProvider {
    static var previews: some View {
        CourseView()
    }
}
