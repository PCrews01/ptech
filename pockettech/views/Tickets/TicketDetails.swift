//
//  TicketDetails.swift
//  pockettech
//
//  Created by Paul Crews on 5/20/23.
//

import SwiftUI
import Foundation

struct RequestData: Encodable {
    let prompt: String
    let maxTokens: Int

    enum CodingKeys: String, CodingKey {
        case prompt
        case maxTokens = "max_tokens"
    }
}
struct TicketDetails: View {
    @State var my_response: String = ""
    @State var responses: [String] = []
    @State var scroll_me = false
    @State var selected: String = ""
    @State var ai_response = ""
    
    var ticket: Ticket
    var body: some View {
        GeometryReader{
            geo in
            VStack{
                Spacer()
                ScrollView{
                    ScrollViewReader{ sreader in
                        VStack{
                            MessageBubble(ticket_content: formatMessage(message:ticket.FirstComment), sender_receiver: "user")
                                .frame(minHeight: 100, idealHeight: geo.size.height)
                            ForEach(responses, id:\.self){
                                res in
                                    MessageBubble(ticket_content: res, sender_receiver: "tech")
                            }
                        }
                    }
                }
                
                
                HStack{
                    TextField("Response", text: $my_response)
                        .frame(height: 55)
                        .padding(3)
                        .background(Material.ultraThickMaterial)
                        .cornerRadius(10)
                    Button {
                        scroll_me = true
                        responses.append(my_response)
                        my_response = ""
                    } label: {
                        Text("Submit")
                            .foregroundColor(.white)
                            .font(.caption)
                            .frame(width: 50, height: 55)
                            .background(Color("dark_green"))
                            .cornerRadius(10)
                    }

                }
                .padding()
                .background(Color("light_green"))
            }.navigationTitle(ticket.TicketTitle)
                .toolbar {
                    Picker(selection: $selected) {
                        Image(systemName: "bolt")
                            .tag("plus")
                        HStack{
                            Image(systemName: "book")
                            Text("KB Resolutions")
                        }.tag("kb")
                        HStack{
                            Image(systemName: "face.dashed")
                            Text("AI Solution")
                        }.tag("AI")
                    } label: {
                        Text("Help").tag("Help")
                    }
                    
                }
                .onChange(of: selected) { newValue in
                    if newValue == "AI"{
                        generateResponse(prompt: ticket.FirstComment, instruction: false)
                    } else {
                        print("Nothing")
                    }
                }
        }
    }
    func formatMessage(message:String) -> String{
        let formatted_message = message.split(separator: "You received this message because you are subscribed to the Google Group")[0]
        if formatted_message.count < 100{
            print("KhhhK \(formatted_message.count) --- \((100 / 40) * 100)")
        } else {
            print("KK \(formatted_message.count) --- \((formatted_message.count / 40) * 100)")
        }
        return String(formatted_message)
    }
    func generateResponse(prompt: String, instruction: Bool) {
        let apiKey = "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"
        let url = URL(string: "https://api.openai.com/v1/engines/text-davinci-003/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let inputData = RequestData(prompt: ai_response.isEmpty ? "Can you parse this email and show me how to fix the problem:  \(prompt)" : "Can you show me further instructions for: \(ai_response).", maxTokens: 300)
        print("OKLM \(inputData.prompt)")
        let jsonEncoder = JSONEncoder()
        request.httpBody = try? jsonEncoder.encode(inputData)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(" ERROR \(error.localizedDescription)")
                return
            }
            
            if let data = data {
                let jsonDecoder = JSONDecoder()
                if let responseJSON = try? jsonDecoder.decode(Response.self, from: data) {
                    let generatedText = responseJSON.choices.first?.text
                    print(" PPP{S \(String(describing: generatedText))")
                    if ai_response == "" || ai_response != generatedText{
                        ai_response = generatedText!
                    }
                    responses.append("AI: \(generatedText!)")
                    return
                }
            }
        }
        
        task.resume()
    }

    struct Response: Codable {
        let choices: [Choice]
    }

    struct Choice: Codable {
        let text: String
    }
}
