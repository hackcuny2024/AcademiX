import SwiftUI

// main chat view
struct ChatView: View {
    @State private var isChannelsListShown = false // tracks if the channel list is shown
    @State private var selectedChannel = "General" // currently selected channel
    @State private var message = "" // message input by user

    // the main body of the chat view
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // chat area on the right
                ChatArea(selectedChannel: $selectedChannel, message: $message)
                    .offset(x: isChannelsListShown ? geometry.size.width * 0.4 : 0) // moves the chat area when channel list is shown
                    .frame(width: geometry.size.width, height: geometry.size.height)

                // channel list on the left
                if isChannelsListShown {
                    ChannelListView(selectedChannel: $selectedChannel, width: geometry.size.width * 0.95)
                }
            }
            // gesture for showing/hiding channel list
            .gesture(dragGesture(width: geometry.size.width))
        }
        .navigationBarTitleDisplayMode(.inline)
        // navigation bar button to toggle channel list
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if isChannelsListShown {
                    Button(action: {
                        withAnimation {
                            isChannelsListShown.toggle() // animates the showing/hiding of the channel list
                        }
                    }) {
                        Image(systemName: "chevron.left.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                }
            }
        }
    }

    // gesture recognizer for channel list
    private func dragGesture(width: CGFloat) -> some Gesture {
        DragGesture()
            .onChanged { value in
                let threshold: CGFloat = width * 0.1 // for recognizing drag
                
                
                // shows/hides channel list based on drag direction
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

// list of channels
struct ChannelListView: View {
    @Binding var selectedChannel: String // currently selected channel
    var width: CGFloat // width of the channel list

    var body: some View {
        VStack {
            List {
                ChannelLink(name: "General", isSelected: selectedChannel == "General", selectedChannel: $selectedChannel)
                ChannelLink(name: "Random", isSelected: selectedChannel == "Random", selectedChannel: $selectedChannel)
            }
            .listStyle(PlainListStyle()) // removes default list styling
        }
        .frame(width: width) // sets the frame to the specified width
        .background(Color.white) // background color for the channel list
    }
}

// link for a channel
struct ChannelLink: View {
    var name: String // name of the channel
    var isSelected: Bool // is the channel currently selected
    @Binding var selectedChannel: String // binding to the current selected channel

    var body: some View {
        HStack {
            Image(systemName: "bubble.left.and.bubble.right")
                .foregroundColor(isSelected ? .blue : .gray)
            Text(name)
                .foregroundColor(isSelected ? .black : .gray)
            Spacer() // pushes content to the left
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle()) // makes the entire row tappable
        .background(isSelected ? Color.blue.opacity(0.2) : Color.clear) // background color when selected
        .onTapGesture {
            selectedChannel = name // updates the selected channel on tap
        }
    }
}

// chat area where messages are displayed
struct ChatArea: View {
    @Binding var selectedChannel: String // currently selected channel
    @Binding var message: String // message input by user

    var body: some View {
        ZStack{
            Image("AcademiXLogo")
//                .resizable()
                .scaledToFill()
                .opacity(0.1) // Adjust the opacity to make the logo more or less transparent
//                .edgesIgnoringSafeArea(.all) // Make the image extend to the edges of the view
            VStack {
                Text(" \(selectedChannel)")
                    .font(Font.custom("Menlo Regular", size: 22))
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.gray.opacity(0.15)) // background color for the title area

                // scrollable area for messages
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(0..<20, id: \.self) { _ in
                            MessageView(username: "John Doe", content: "When's the homework due?")
                                .font(Font.custom("Menlo Regular", size: 16))
                        }
                    }
                    .padding()
                }
                
                // message input area
                HStack {
                    TextField("Message \(selectedChannel)", text: $message)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button("Send", action: sendMessage) // button to send a message
                }
                .font(Font.custom("Menlo Regular", size: 16))
                .padding()
            }
        }

 
        .background(Color.white) // background color for the chat area
    }
    
    func sendMessage() {
        // logic to send a message
    }
}

// individual message view
struct MessageView: View {
    var username: String // user who sent the message
    var content: String // message content

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Circle()
                .frame(width: 40, height: 40)
                .foregroundColor(.black) // user icon
            VStack(alignment: .leading) {
                Text(username).bold()
                Text(content)
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
