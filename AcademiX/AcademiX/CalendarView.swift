//
//  CalendarView.swift
//  AcademiX
//
//  Created by Olti Gjoni on 2/17/24.
//
import SwiftUI

struct Event: Identifiable {
    let id = UUID()
    let title: String
    let date: Date
}

class WeekViewModel: ObservableObject {
    @Published var events: [Event] = []
    
    init() {
        // Dummy data for demonstration
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        events.append(Event(title: "MATH", date: formatter.date(from: "2024/02/12")!))
        events.append(Event(title: "ENGL", date: formatter.date(from: "2024/02/13")!))
        events.append(Event(title: "SPAN", date: formatter.date(from: "2024/02/13")!))
        events.append(Event(title: "GERM", date: formatter.date(from: "2024/02/14")!))
        events.append(Event(title: "CSCI", date: formatter.date(from: "2024/02/16")!))
        events.append(Event(title: "ART", date: formatter.date(from: "2024/02/16")!))

        // Add more dummy events if needed for demonstration
    }
    
    func events(for day: Date) -> [Event] {
        events.filter { Calendar.current.isDate($0.date, inSameDayAs: day) }
    }
}

struct CalendarView: View {
    @ObservedObject var viewModel = WeekViewModel()
    let daysOfWeek = Calendar.current.shortWeekdaySymbols
    
    var body: some View {
        VStack {
            // Weekly Overview section
            VStack(alignment: .center) {
                Text("Weekly Overview")
                    .font(Font.custom("Menlo Regular", size: 30))
                    .padding()
                
                HStack(alignment: .top) {
                    ForEach(0..<7, id: \.self) { index in
                        VStack {
                            // Display date above day of the week
                            Text("\(self.dateFor(dayOfWeek: index + 1), formatter: DateFormatter.shortDate)")
                                .font(Font.custom("Menlo Regular", size: 8.4))
                                .foregroundColor(.gray)
                                .padding(.bottom, 1)
                            
                            Text(self.daysOfWeek[index])
                                .font(.subheadline)
                            
                            ForEach(viewModel.events(for: self.dateFor(dayOfWeek: index + 1)), id: \.id) { event in
                                Text(event.title)
                                    .font(Font.custom("Menlo Regular", size: 12))
                                    .foregroundColor(.blue)
                                    .padding(.top, 1)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                        // Add divider except for the last item
                        if index < 6 {
                            Divider().background(Color.gray.opacity(0.5))
                        }
                    }
                }
                .padding(.horizontal)
            }
            .frame(maxHeight: .infinity, alignment: .top) // Limit to top half of the screen
            
            Divider()
          
            ZStack {
                // Set the background for the entire screen area
                
                Image("Background2") // Replace "yourBackgroundImageName" with your actual image file name
                    .resizable() // This will allow the image to resize to fit the container
                    .edgesIgnoringSafeArea(.all) // Make sure it extends to the edges of the screen
                    .opacity(0.08)


                VStack {
                    // Event Viewer section
                    Text("Event Overview")
                        .padding(12)
                        .background(Color.white) // Set the background color to white
                        .cornerRadius(12) // Optionally, add a corner radius to smooth the edges
                        .font(Font.custom("Menlo Regular", size: 23))
                        .padding()
                    List {
                        ForEach(viewModel.events) { event in
                            HStack {
                                Text(event.title)
                                    .font(Font.custom("Menlo Regular", size: 18))
                                
                                Divider()
                                Text("\(event.date, formatter: DateFormatter.shortDate)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 7)
                        }
                    }
                }
                .padding() // Adds some space between the edges of the screen and the VStack content
            }
            .frame(maxHeight: .infinity, alignment: .bottom) // Limit to bottom half of the screen
        }
    }
    
    func dateFor(dayOfWeek: Int) -> Date {
        let today = Date()
        let weekday = Calendar.current.component(.weekday, from: today)
        
        // Calculate the start of the week (Sunday)
        let daysToSubtract = weekday == 1 ? 0 : -(weekday - 1)
        let startOfWeek = Calendar.current.date(byAdding: .day, value: daysToSubtract, to: today)!
        
        // Calculate the specific day of the week
        let desiredDate = Calendar.current.date(byAdding: .day, value: dayOfWeek - 1, to: startOfWeek)!
        return desiredDate
    }
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
