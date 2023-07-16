//
//  TicketsView.swift
//  pockettech
//
//  Created by Paul Crews on 5/20/23.
//

import SwiftUI
import AVKit
import PhotosUI

struct TicketsView: View {
    
    @State var tickets:[Ticket] = []
    @State var time_ran: Date = Date()
    @State var selected: String = ""
    @State var pre_size: CGFloat = 0
    @State var selected_size: CGFloat = 0
    @State var ticket_filter = ""
    @State var bg_color = Color.gray.opacity(0.45)
    @State var card_font_color = Color.white
    @State var new_ticket: Ticket = demo_ticket
    @State var show_ticket_form = false
    @State var permission_granted = false
   
    var body: some View {
        GeometryReader{ geo in
            VStack{
                Spacer()
                HStack{
                    TextField("Search By Technician", text: $ticket_filter)
                        .padding()
                        .background(.regularMaterial)
                        .onChange(of: ticket_filter) { newValue in
                            if ticket_filter.count >= 3 {
                                withAnimation(.linear(duration: 0.8)) {
                                    bg_color = Color("light_green")
                                    card_font_color = Color(.white)
                                }
                            } else {
                                withAnimation(.linear(duration: 0.8)){
                                    card_font_color = Color.black
                                    bg_color = Color.gray.opacity(0.45)
                                }
                            }
                        }
                    if ticket_filter.count > 2 {
                        Button {
                            ticket_filter = ""
                        } label: {
                            Text("Clear")
                        }
                    }
                }
                HStack(alignment: .center){
                    NavigationLink {
                        NewTicketView(new_ticket: new_ticket, permission_granted: $permission_granted)
                    } label: {
                        Text("New Ticket")
                    }
                    .padding()
                    .foregroundColor(.primary)
                    .background(Color("light_green"))
                    .cornerRadius(12)
                    .frame(width: 400, height: 20)
                    .padding()

                }
                
                ScrollView(showsIndicators: true){
                    LazyVGrid(columns: getDeviceOrientation() == "Landscape" ? gridColumns(columns: 4) : gridColumns(columns: 2)){
                        ForEach(tickets, id:\.self) { tk in
                            if ticket_filter.count < 1 || (tk.TechnicianFullName ?? tk.TicketTitle).contains(ticket_filter) {
                                    NavigationLink {
                                        TicketView(ticket: tk)
                                    } label: {
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(tk.TicketStatus == "Open" ? Color("light_green") : tk.TicketStatus == "Resolved" ? Color("AccentColor") : .gray.opacity(0.45))
                                           
                                            HStack{
                                                ForEach(getFlames(severity: tk.TicketPriority).indices, id:\.self) { flame in
                                                    Image(systemName: "flame")
                                                        .resizable()
                                                        
                                                        .foregroundColor(.red)
                                                        .opacity(0.5)
                                                        .frame(width: 30, height: 30)
                                                }
                                            }
                                            
                                            VStack(alignment: .leading){
                                                HStack{
                                                    Text("Ticket No.")
                                                    Spacer()
                                                    Text("\(tk.TicketID)")
                                                }
                                                .font(.caption)
                                                Divider()
                                                Spacer()
                                                        Text("\(tk.TicketTitle)")
                                                    .lineLimit(3)
                                                    .multilineTextAlignment(.leading)
                                                            .fontWeight(.semibold)
                                                            .padding(.bottom, 5)
                                                Spacer()
                                                HStack{
                                                    Spacer()
                                                    Image(systemName: "person.circle")
                                                        .resizable()
                                                        .frame(width: 15, height: 15)
                                                    Text(tk.TechnicianFullName?.split(separator: " ")[0] ?? "Not Assigned")
                                                        .font(.caption)
                                                        .fontWeight(.semibold)
                                                        .padding(.leading, 3)
                                                }
                                            }
                                            .padding()
                                            .foregroundColor(.white)
                                            .background(.ultraThinMaterial.opacity(0.4))
                                        }
                                        .cornerRadius(10)
                                        .background(Material.ultraThinMaterial)
                                        .frame(minHeight: 200)
                                    }
                                }
                            
                        }
                    }.onAppear {
                        fetchTickets()
                    }
                    .navigationTitle("Tickets")
                }.refreshable {
                    fetchTickets()
                }
            }
        }
    }
  
    func fetchTickets() {
            guard let url = URL(string: "https://app.atera.com/api/v3/tickets") else {
                print("Invalid URL")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("7c215afdf2a346df8469ba88dc909771", forHTTPHeaderField: "X-API-KEY")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                guard let datab = data else {
                    print("No data received")
                    return
                }
                
                do {
                    let skr = String(data: datab, encoding: .utf8)
                    guard let jsonData = skr!.data(using: .utf8) else {
                        print("Failed to convert JSON string to data.")
                        return
                    }
                    
                    let decoder = JSONDecoder()
                    do {
                        let response = try decoder.decode(TicketResponse.self, from: jsonData)
                        tickets = response.items
                    } catch {
                        print("Failed to decode JSON data: \(error)")
                    }
                }
                
            }.resume()
        }
    }

struct TicketsView_Previews: PreviewProvider {
    static var previews: some View {
        TicketsView()
    }
}
