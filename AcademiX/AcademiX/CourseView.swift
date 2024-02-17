import SwiftUI

// The main view displaying a list of courses
struct CourseView: View {
    @State private var showingSignUp = false
    let courses = ["Computer Science 101", "Philosophy 202", "Mathematics 303"] // Sample courses

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
                    Button("Sign Up") {
                        showingSignUp = true
                    }
                }
            }
            .sheet(isPresented: $showingSignUp) {
                HomeView() // Present the HomeView when "Sign Up" is tapped
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
