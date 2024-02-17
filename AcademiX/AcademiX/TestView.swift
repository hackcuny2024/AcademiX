//
//  TestView.swift
//  AcademiX
//
//  Created by Olti Gjoni on 2/17/24.
//

import SwiftUI

struct TestView: View {
    @State private var class_: Class?
    @State private var errorText: String?

    
    var body: some View {
        VStack {
            Text(class_?.name ?? "Class Name Placeholder")
            Text(errorText ?? "Error Placeholder")

        }
        .task {
            do {
                class_ = try await getClass()
            } catch APIError.invalidURL {
                errorText = "invalidURL"
            } catch APIError.invalidResponse {
                errorText = "invalidResponse"
            } catch APIError.invalidData {
                errorText = "invalidData"
            } catch {
                print("unexpected error")
            }
            
        }
    }

}

func getClass() async throws -> Class  {
    
    let endpoint = "http://217.25.90.34:8500/api/classes/527f0a01-1f83-40cb-8929-fcb5d47b5438"
    
    guard let url = URL(string: endpoint) else {
        throw APIError.invalidURL
    }
            
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        throw APIError.invalidResponse
    }
    
    do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(Class.self, from: data)
    } catch {
        throw APIError.invalidData
    }
}

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}

struct Class: Codable {
    let name: String
    let id: String
    let adminUsername: String

    let info: String?
    
    let sunday: String?
    let monday: String?
    let tuesday: String?
    let wednesday: String?
    let thursday: String?
    let friday: String?
    let saturday: String?
}


#Preview {
    TestView()
}
