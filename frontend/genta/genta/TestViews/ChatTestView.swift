//import SwiftUI
//
//struct Message: Identifiable {
//    let id = UUID()
//    let text: String
//    let isSentByUser: Bool
//}
//
//struct ChatTestView: View {
//    @State private var messages: [Message] = [
//        Message(text: "Hello!", isSentByUser: false),
//        Message(text: "Hi there!", isSentByUser: true),
//        Message(text: "How are you?", isSentByUser: false),
//        Message(text: "I'm good, thanks!", isSentByUser: true)
//    ]
//
//    var body: some View {
//        VStack {
//            List(messages) { message in
//                MessageRow(message: message)
//            }
//            .onAppear {
//                // Scroll to the last message when the view appears
//                scrollToLastMessage()
//            }
//
//            HStack {
//                TextField("Type a message", text: .constant(""))
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//
//                Button("Send") {
//                    sendMessage()
//                }
//            }
//            .padding()
//        }
//        .navigationTitle("Chat")
//    }
//
//    func sendMessage() {
//        let newMessage = Message(text: "New message", isSentByUser: true)
//        messages.append(newMessage)
//        scrollToLastMessage()
//    }
//
//    func scrollToLastMessage() {
//        guard let lastMessage = messages.last else { return }
//        withAnimation {
//            // Scroll to the last message
//        }
//    }
//}
//
//struct MessageRow: View {
//    let message: Message
//
//    var body: some View {
//        HStack {
//            if message.isSentByUser {
//                Spacer()
//            }
//
//            Text(message.text)
//                .padding(10)
//                .background(message.isSentByUser ? Color.blue : Color.gray)
//                .foregroundColor(.white)
//                .cornerRadius(10)
//
//            if !message.isSentByUser {
//                Spacer()
//            }
//        }
//    }
//}
//
//struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            ChatTestView()
//        }
//    }
//}
