import SwiftUI

// Model for a thread
struct Thread: Identifiable, Decodable {
    var id: String
    var name: String
}

// Model for a message
struct Message1: Identifiable, Codable {
    var id: String
    var created_at: String
    var class_id: String
    var sender_id: String
    var sender_name: String
    var thread_id: String
    var text: String
}

// Service to fetch threads
class ThreadService: ObservableObject {
    @Published var threads: [Thread] = []

    func fetchThreads() {
        let classId = "527f0a01-1f83-40cb-8929-fcb5d47b5438"
        guard let url = URL(string: "http://217.25.90.34:8500/api/threads/?class_id=\(classId)") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let data = data {
                    let decodedThreads = try JSONDecoder().decode([Thread].self, from: data)
                    DispatchQueue.main.async {
                        self.threads = decodedThreads
                    }
                } else {
                    print("No data")
                }
            } catch {
                print("Error fetching threads: \(error)")
            }
        }.resume()
    }
}

// Service to fetch and send messages
class MessageService: ObservableObject {
    @Published var messages: [Message1] = []

    func fetchMessages(for threadId: String) {
        let classId = "527f0a01-1f83-40cb-8929-fcb5d47b5438"
        guard let url = URL(string: "http://217.25.90.34:8500/api/messages/?class_id=\(classId)&thread_id=\(threadId)") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let data = data {
                    let decodedMessages = try JSONDecoder().decode([Message1].self, from: data)
                    DispatchQueue.main.async {
                        self.messages = decodedMessages
                    }
                } else {
                    print("No data")
                }
            } catch {
                print("Error fetching messages: \(error)")
            }
        }.resume()
    }

    func sendMessage(threadId: String, senderId: String, text: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://217.25.90.34:8500/api/messages/") else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "sender_id": senderId,
            "thread_id": threadId,
            "text": text
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                DispatchQueue.main.async {
                    completion(true)
                }
            } else {
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }.resume()
    }
}

// Main chat view
struct ChatView: View {
    @StateObject var threadService = ThreadService()
    @StateObject var messageService = MessageService()
    @State private var isChannelsListShown = false
    @State private var selectedChannel: Thread?
    @State private var message = ""

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if let selectedChannel = selectedChannel {
                    ChatArea(selectedChannel: selectedChannel, message: $message, messageService: messageService)
                        .offset(x: isChannelsListShown ? geometry.size.width * 0.4 : 0)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                } else {
                    // Placeholder content
                    Text("Select a channel to start chatting")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.gray.opacity(0.1))
                }

                if isChannelsListShown {
                    ChannelListView(selectedChannel: $selectedChannel, width: geometry.size.width * 0.95, threads: threadService.threads, messageService: messageService)
                }
            }
            .gesture(dragGesture(width: geometry.size.width))
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if isChannelsListShown {
                    Button(action: {
                        withAnimation {
                            isChannelsListShown.toggle()
                        }
                    }) {
                        Image(systemName: "chevron.left.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                }
            }
        }
        .onAppear {
            print("ChatView appeared")
            threadService.fetchThreads()
        }
    }

    private func dragGesture(width: CGFloat) -> some Gesture {
        DragGesture()
            .onChanged { value in
                let threshold: CGFloat = width * 0.1
                if value.translation.width > threshold && !isChannelsListShown {
                    withAnimation {
                        isChannelsListShown = true
                    }
                } else if value.translation.width < -threshold && isChannelsListShown {
                    withAnimation {
                        isChannelsListShown = false
                    }
                }
            }
    }
}

// List of channels
struct ChannelListView: View {
    @Binding var selectedChannel: Thread?
    var width: CGFloat
    var threads: [Thread]
    var messageService: MessageService

    var body: some View {
        VStack {
            List {
                ForEach(threads) { thread in
                    ChannelLink(thread: thread, isSelected: selectedChannel?.id == thread.id, selectedChannel: $selectedChannel, messageService: messageService)
                }
            }
            .listStyle(PlainListStyle())
        }
        .frame(width: width)
        .background(Color.white)
    }
}

// Link for a channel
struct ChannelLink: View {
    var thread: Thread
    var isSelected: Bool
    @Binding var selectedChannel: Thread?
    var messageService: MessageService

    var body: some View {
        HStack {
            Image(systemName: "bubble.left.and.bubble.right")
                .foregroundColor(isSelected ? .blue : .gray)
            Text(thread.name)
                .foregroundColor(isSelected ? .black : .gray)
            Spacer()
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .background(isSelected ? Color.blue.opacity(0.2) : Color.clear)
        .onTapGesture {
            selectedChannel = thread
            messageService.fetchMessages(for: thread.id)
        }
    }
}

// Chat area where messages are displayed
struct ChatArea: View {
    var selectedChannel: Thread
    @Binding var message: String
    @ObservedObject var messageService: MessageService

    var body: some View {
        ZStack {
            // Replace "AcademiXLogo" with your actual logo asset name if it exists,
            // or remove the Image
            // If you don't have an image named "AcademiXLogo", you can comment out this line
            // Image("AcademiXLogo")
            //     .scaledToFill()
            //     .opacity(0.1)
            
            VStack {
                Text(selectedChannel.name)
                    .font(Font.custom("Menlo Regular", size: 22))
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.gray.opacity(0.15))

                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(messageService.messages) { message in
                            MessageView(username: message.sender_name, content: message.text)
                                .font(Font.custom("Menlo Regular", size: 16))
                        }
                    }
                    .padding()
                }
                
                HStack {
                    TextField("Message \(selectedChannel.name)", text: $message)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button("Send", action: {
                        messageService.sendMessage(threadId: selectedChannel.id, senderId: "90afdca5-ee2a-4de7-b2f4-a35a6a7f3bdc", text: message) { success in
                            if success {
                                print("Message sent successfully")
                                message = ""
                                messageService.fetchMessages(for: selectedChannel.id) // Reload messages after sending
                            } else {
                                print("Failed to send message")
                            }
                        }
                    })
                }
                .font(Font.custom("Menlo Regular", size: 16))
                .padding([.horizontal, .top])
                .padding(.bottom, 75) // Reduced bottom padding
            }
        }
        .background(Color.white)
    }
}

// Individual message view
struct MessageView: View {
    var username: String
    var content: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Circle()
                .frame(width: 40, height: 40)
                .foregroundColor(.blue) // Placeholder for user icon
            VStack(alignment: .leading) {
                Text(username).bold()
                Text(content)
            }
            Spacer()
        }
        .padding(.horizontal)
    }
}

// Preview provider
struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
