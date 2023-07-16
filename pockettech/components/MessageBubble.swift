//
//  MessageBubble.swift
//  pockettech
//
//  Created by Paul Crews on 5/21/23.
//

import SwiftUI
struct MessageButton{
    let id = UUID().uuidString
    let icon:String
    let action: String
    let background: Color
    
}
struct MessageBubble: View {
    @State var ticket_content: String
    @State var buttons = [
        MessageButton(icon: "hand.thumbsdown.circle", action: "Thumbs Up", background: Color.red),
        MessageButton(icon: "book", action: "KB", background: Color.white),
        MessageButton(icon: "hand.thumbsup.circle", action: "Thumb Down", background: Color("light_green"))]
    @State var sender_receiver: String
    @State var show_menu = false
    @State var my_menu: String = ""
    var body: some View {
        GeometryReader{ geo in
            HStack{
                if sender_receiver == "tech"{
                    Spacer()
                }
                ZStack{
                    VStack{
                        Text(ticket_content)
                            .foregroundColor(.white)
                        Spacer()
                        if show_menu && my_menu == ticket_content{
                            HStack{
                                Spacer()
                                ForEach(buttons, id: \.id){
                                    button in
                                    Button {
                                        print("This is \(button.icon)")
                                    } label: {
                                        ZStack{
                                            Circle()
                                                .fill(button.background)
                                                .frame(width: 30, height: 30)
                                            
                                            Image(systemName: "\(button.icon)")
                                                .resizable()
                                                .foregroundColor(button.background == Color.white ? Color("light_green") : Color.white)
                                                .frame(width: 20, height: 20)
                                        }
                                    }
                                    
                                }
                                Spacer()
                            }
                            .frame(width: geo.size.width - 50, height: 50, alignment:.center)
                            .background(Color.green)
                        }
                        }
                    .padding()
                    .background(sender_receiver == "user" ? Color("AccentColor") : Color("light_green"))
                }
                .padding(5)
                .frame(minWidth: 150, maxWidth: geo.size.width - 50, alignment: .center)
                .padding()
                if sender_receiver == "user"{
                    Spacer()
                }
            }.onLongPressGesture {
                show_menu.toggle()
                my_menu = ticket_content
            }
            
        }
    }
}

struct MessageBubble_Previews: PreviewProvider {
    static var previews: some View {
        @State var ticket_content = "Picker: the selection is invalid and does not have an associated tag, this will give undefined results."
        MessageBubble(ticket_content: ticket_content, sender_receiver: "user")
    }
}
