//
//  TicketView.swift
//  pockettech
//
//  Created by Paul Crews on 5/20/23.
//

import SwiftUI
import Alamofire

struct UpdateTicket: Encodable {
      var TicketTitle: String
      var TicketStatus: String
      var TicketType: String
      var TicketPriority: String
      var TicketImpact: String
      var TechnicianContactID: Int
}

struct TicketView: View {
    var ticket: Ticket
    @State var toolbar: [String:Any] = [:]
    @State var show_info: Bool = false
    @State var my_response: String = ""
    @State var responses: [String] = []
    @State var ai_response = ""
    @State var selected: String = ""
    @State var generating_response:Bool = false
    @State var ticket_update: String = ""
    
    var body: some View {
        GeometryReader{
            geo in
                    VStack{
                        VStack{
                            Text("\(ticket.TicketTitle)")
                            Text("From: \(ticket.EndUserFirstName) \(ticket.EndUserLastName)")
                                .font(.caption)
                                .frame(width: geo.size.width - 20, alignment: .leading)
                            Text("Email: \(ticket.EndUserEmail)")
                                .font(.caption)
                                .frame(width: geo.size.width - 20, alignment: .leading)
                            Text("Status: \(ticket.TicketStatus)")
                                .font(.caption)
                                .frame(width: geo.size.width - 20, alignment: .leading)
                            Text("From: \(ticket.TicketPriority)")
                                .font(.caption)
                                .frame(width: geo.size.width - 20, alignment: .leading)
                        }.padding()
                            .foregroundColor(Color.white)
                            .fontWeight(.bold)
                            .frame(width: geo.size.width, alignment: .leading)
                            .background(ticket.TicketStatus == "Open" ? Color("light_green") : ticket.TicketStatus == "Closed" ? Color.gray : Color.accentColor)
                            
                        
                        
                        ScrollView{
                            ScrollViewReader{ sreader in
                                Text(ticket.FirstComment.split(separator: "You received this message because you are subscribed to the Google Group")[0])
                                ForEach(responses, id:\.self){
                                    res in
                                    let n = responses.firstIndex(of: res)
                                    
                                    Divider()
                                    Text(res)
                                        .id(n)
                                }.onChange(of: responses) { val in
                                    let n = responses.count - 1
                                    withAnimation {
                                        sreader.scrollTo(n, anchor: .center)
                                    }
                                    
                                }
                            }
                            
                        }
                        HStack{
                            if !generating_response {
                                TextField("Response", text: $my_response)
                                    .frame(height: 55)
                                    .padding(3)
                                    .background(Material.ultraThickMaterial)
                                    .cornerRadius(10)
                            }
                            Button {
                                responses.append(my_response)
                                my_response = ""
                            } label: {
                                if my_response.count > 3{
                                    Text("Submit")
                                        .foregroundColor(.white)
                                        .font(.caption)
                                        .frame(width: 50, height: 55)
                                        .background(Color("dark_green"))
                                        .cornerRadius(10)
                                } else {
                                    VStack{
                                        Picker(selection: $selected) {
                                            Image(systemName: "bolt")
                                                .tag("plus")
                                            HStack{
                                                Image(systemName: "book")
                                            }.tag("kb")
                                            HStack{
                                                Image(systemName: "face.dashed")
                                                Text(generating_response ? "Generating Response" : " ")
                                                    .foregroundColor(Color.white)
                                            }.tag("AI")
                                        } label: {
                                            Text("Help").tag("Help")
                                        }
                                        .accentColor(.white)
                                        .background(Color("dark_green"))
                                        .cornerRadius(10)
                                        .onChange(of: selected) { newValue in
                                            if newValue == "AI"{
                                                generating_response.toggle()
                                                generateResponse(prompt: ticket.FirstComment, instruction: false)
                                                
                                                
                                            } else {
                                                print("Nothing")
                                            }
                                        }
                                        
                                        
                                            Picker(selection: $ticket_update) {
                                                Text("Mark As")
                                                    .foregroundColor(Color.primary)
                                                    .tag("")
                                                HStack{
                                                    Image(systemName: "square.and.pencil.circle.fill")
                                                    Text("Updated")
                                                        .foregroundColor(Color.white)
                                                }
                                                .tag("update")
                                                HStack{
                                                    Image(systemName: "xmark.seal.fill")
                                                        .foregroundColor(.red)
                                                    Text("Closed")
                                                        .foregroundColor(Color.white)
                                                }.tag("Closed")
                                                HStack{
                                                    Image(systemName: "checkmark.seal.fill")
                                                        .foregroundColor(Color("light_green"))
                                                    Text("Resolved")
                                                        .foregroundColor(Color.white)
                                                }.tag("Resolved")
                                            } label: {
                                                Text("Update").tag("update")
                                            }
                                            .accentColor(.white)
                                            .background(Color("dark_green"))
                                            .cornerRadius(10)
                                            .onChange(of: ticket_update) { newValue in
                                                print("nv \(newValue)")
                                                if newValue == "Resolved" || newValue == "Closed"{
                                                    updateTicket(ticket: ticket)
//                                                    generating_response.toggle()
//                                                    generateResponse(prompt: ticket.FirstComment, instruction: false)
                                                    
                                                    
                                                } else {
                                                    print("Nothing")
                                                }
                                            }


                                    }
                                }
                            }

                        }
                        .padding()
                        .frame(width: geo.size.width)
                        .background(Color("light_green"))

                    }
                    .sheet(isPresented: $show_info, content: {
                        VStack{
                            Text(ticket.TicketTitle)
                                .font(.headline)
                            ScrollView{
                                VStack {
                                    ForEach(ticket.keyValuePairs, id: \.0) { key, value in
                                        HStack{
                                            Text("\(key):")
                                                .fontWeight(.bold)
                                            Spacer()
                                            if type(of: value) == String.self{
                                                Text("\(value as! String)")
                                            } else if type(of: value) == Int.self{
                                                Text("\(value as! Int)")
                                            }
                                        }
                                        .font(.caption)
                                        .frame(minHeight: 25)
                                        Divider()
                                    }
                                }.padding()
                            }
                        }.background(Material.ultraThickMaterial)
                    })
                    .toolbar(content: {
                        Button {
                            show_info.toggle()
                        } label: {
                            Image(systemName: "filemenu.and.cursorarrow")
                        }.foregroundColor(Color.white)

                    })
                    .navigationTitle("Ticket No.: \(ticket.TicketID)")
            
        }
    }
    func updateTicket(ticket: Ticket){
        guard let url = URL(string: "https://app.atera.com/api/v3/tickets/\(ticket.TicketID)") else {
            print("Invalid URL")
            return
        }
        let parameters: Parameters = [
            "TicketStatus": ticket_update
        ]
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type": "text/json",
            "X-API-KEY": "7c215afdf2a346df8469ba88dc909771"
        ]
        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseData(completionHandler: { res in
                print(" RES \(res)")
                switch res.result{
                case .success(let data):
                    do {
                    guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                        print("Error: Cannot convert data to JSON object")
                        return
                    }
                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                        print("Error: Cannot convert JSON object to Pretty JSON data")
                        return
                    }
                    guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                        print("Error: Could print JSON in String")
                        return
                    }
                    
                    print(prettyPrintedJson)
                } catch {
                    print("Error: Trying to convert JSON data to string")
                    return
                }
                case .failure(let error):
                    print("Rrror \(error)")
                }
            })
        
    }
    func updateTickets(ticket: Ticket) {
        
        guard let url = URL(string: "https://app.atera.com/api/v3/tickets/\(ticket.TicketID)") else {
            print("Invalid URL")
            return
        }
        var update_ticket : UpdateTicket = UpdateTicket(TicketTitle: ticket.TicketTitle, TicketStatus: ticket_update, TicketType: ticket.TicketType, TicketPriority: ticket.TicketPriority, TicketImpact: ticket.TicketImpact, TechnicianContactID: ticket.TechnicianContactID ?? 0)
        print("running update")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("7c215afdf2a346df8469ba88dc909771", forHTTPHeaderField: "X-API-KEY")
        
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        let d_data = try? encoder.encode(update_ticket.TicketStatus)
        let updateroo : [String:Any] = ["TicketStatus" : ticket_update]
        struct NBD: Decodable, Encodable{
            var data: [String]
        }
            let j = NBD(data: ["\u{201D}TicketStatus\u{201D}:\u{201D}Closed\u{201D}"])
            
        let mer = try? encoder.encode(j)
            let str = String(data: mer!, encoding: .utf8)
        request.httpBody = mer
        let ny = try? decoder.decode(NBD.self, from: request.httpBody!)
        let strb = ny?.data
        print("HTTP \(String(describing: ny))")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print("Data \(String(describing: data))")
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            print("Deleted Alert \(response.unsafelyUnwrapped)")
        }
            task.resume()
    }
    
    func generateResponse(prompt: String, instruction: Bool) {
        let apiKey = "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"
        let url = URL(string: "https://api.openai.com/v1/engines/text-davinci-003/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("\(apiKey)", forHTTPHeaderField: "API-KEY")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("text/json", forHTTPHeaderField: "Accept")
        
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
                    if ai_response == "" || ai_response != generatedText{
                        ai_response = generatedText!
                    }
                    responses.append("AI: \(generatedText!)")
                    return
                }
            }
        }
        
        task.resume()
        if task.state == .running{
            generating_response = true
        } else if task.state == .completed{
            generating_response = false
        }
    }

    struct Response: Codable {
        let choices: [Choice]
    }

    struct Choice: Codable {
        let text: String
    }

}
extension Ticket {
    var keyValuePairs: [(String, Any)] {
        let mirror = Mirror(reflecting: self)
        return mirror.children.compactMap {
            guard let label = $0.label else { return nil }
            return (label, $0.value)
        }
    }
}
