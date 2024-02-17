//
//  ClassmatesPullTest.swift
//  AcademiX
//
//  Created by Moe Bazrouk on 2/17/24.
//

import SwiftUI

struct ClassmatesView: View {
    let classId: String
    @State private var classmates: [Classmate] = []
    @State private var errorText: String?

    var body: some View {
        VStack {
            if classmates.isEmpty {
                Text(errorText ?? "Loading...")
            } else {
                List(classmates) { classmate in
                    Text(classmate.name)
                }
            }
        }
        .navigationTitle("Classmates")
        .task {
            await fetchClassmates()
        }
    }

    func fetchClassmates() async {
        let endpoint = "http://217.25.90.34:8500/api/classmates?class_id=\(classId)"
        
        guard let url = URL(string: endpoint) else {
            errorText = "Invalid URL"
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                errorText = "Invalid Response"
                return
            }
            
            let decoder = JSONDecoder()
            classmates = try decoder.decode([Classmate].self, from: data)
        } catch {
            errorText = "Failed to fetch classmates: \(error.localizedDescription)"
        }
    }
}

struct Classmate: Identifiable, Codable {
    let id: String
    let name: String
}

struct ClassmatesView_Previews: PreviewProvider {
    static var previews: some View {
        ClassmatesView(classId: "527f0a01-1f83-40cb-8929-fcb5d47b5438")
    }
}
