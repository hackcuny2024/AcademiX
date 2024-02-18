import SwiftUI
import OpenAI
import Combine

struct Message: Identifiable {
    var id = UUID()
    var content: String
    var isUser: Bool
}

class ChatController: ObservableObject {
    @Published var messages: [Message] = []
    @Published var scrollToBottomID = UUID() // Used to auto-scroll to the latest message.
    @Published var isKeyboardVisible = false // Flag to track keyboard visibility
    private var messagesByLanguage: [String: [Message]] = [:]
    var selectedLanguage: String = "English" {
        didSet {
            messages = messagesByLanguage[selectedLanguage, default: []]
        }
    }
    let openAI = OpenAI(apiToken: "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") // Securely manage your API key.

    func sendNewMessage(content: String) {
        let userMessage = Message(content: content, isUser: true)
        messages.append(userMessage)
        messagesByLanguage[selectedLanguage, default: []].append(userMessage)
        scrollToBottomID = userMessage.id
        getBotReply(content: content)
    }

    func getBotReply(content: String) {
        openAI.chats(query: .init(model: .gpt3_5Turbo,
                                  messages: self.messages.map({ Chat(role: .user, content: $0.content)}),
                                  maxTokens: 50)) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    guard let choice = success.choices.first else {
                        return
                    }
                    let message = choice.message.content
                    let botMessage = Message(content: message ?? "No response", isUser: false)
                    self?.messages.append(botMessage)
                    self?.messagesByLanguage[self?.selectedLanguage ?? "English", default: []].append(botMessage)
                    self?.scrollToBottomID = botMessage.id
                case .failure(let failure):
                    print(failure.localizedDescription) // Print error message to console
                }
            }
        }
    }

    func switchLanguage(to newLanguage: String) {
        selectedLanguage = newLanguage
    }

    func clearMessages() {
        DispatchQueue.main.async {
            self.messages.removeAll()
        }
    }
}

struct TestView: View {
    @StateObject var chatController = ChatController()
    @State private var string: String = ""
    @State private var selectedLanguage: String = "English"
    let languages = ["English", "Spanish", "French", "German","Italian"]

    var body: some View {
        ZStack{
            Image("AcademiXLogo")
                .scaledToFill()
                .opacity(0.1)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Picker("Language", selection: $selectedLanguage) {
                    ForEach(languages, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .onChange(of: selectedLanguage) { newValue in
                    chatController.switchLanguage(to: newValue)
                }
                
                ScrollViewReader { scrollView in
                    ScrollView {
                        VStack {
                            ForEach(chatController.messages) { message in
                                TranslatorMessageView(message: message)
                                    .padding(5)
                                    .id(message.id)
                            }
                            .padding(.bottom, 20)
                        }
                        .onChange(of: chatController.scrollToBottomID) { id in
                            withAnimation {
                                scrollView.scrollTo(id, anchor: .bottom)
                            }
                        }
                    }
                }
                
                HStack {
                    TextField("Message...", text: $string)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(15)
                    
                    Button(action: {
                        chatController.sendNewMessage(content: string)
                        string = "" // Clear the text field after sending
                    }) {
                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    .padding(.horizontal)
                }
                .frame(height: 50)
                .background(Color.white)
                .cornerRadius(10)
                .padding(.horizontal, 10)
                .padding(.bottom, 80)
            }
//            .padding(.bottom, 100)
        }
        .navigationBarTitle("Chat")
        .navigationBarHidden(chatController.isKeyboardVisible) // Hide navigation bar when keyboard is visible
        .navigationViewStyle(StackNavigationViewStyle())
        .onReceive(Publishers.keyboardHeight) { keyboardHeight in
            chatController.isKeyboardVisible = keyboardHeight > 0
        }
    }
}

struct GestureDetector<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            Color.clear.contentShape(Rectangle()).onTapGesture { hideKeyboard() }
            content
        }
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct TranslatorMessageView: View {
    var message: Message

    var body: some View {
        HStack(alignment: .top) { // Ensure alignment starts from the top for variable text lengths
            if message.isUser {
                Spacer() // Push user messages to the right
                Text(message.content)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .cornerRadius(15)
            } else {
                Image("AcademiXLogo") // AI "profile" icon
                    .resizable()
                    .aspectRatio(contentMode: .fill) // Maintain the aspect ratio while filling the frame
                    .frame(width: 50, height: 50) // Increase the frame size as needed
                    .clipShape(Circle()) // Optional: Clip as circle shape if desired
                    .padding(.leading, 5) // Adjust padding from the leading edge
                    .padding(.top, 5) // Add padding on top to better align with the text
                
                Text(message.content) // AI message
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(Color.white)
                    .cornerRadius(15)

                Spacer() // Push AI messages to the left
            }
        }
        .padding(.horizontal) // Add horizontal padding to the entire message bubble for spacing
    }
}


struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}

// Extension to get the keyboard height
extension Publishers {
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { $0.keyboardHeight }
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}

private extension Notification {
    var keyboardHeight: CGFloat {
        (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
}

