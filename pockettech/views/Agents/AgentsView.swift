//
//  AgentsView.swift
//  pockettech
//
//  Created by Paul Crews on 5/29/23.
//

import SwiftUI



struct AgentsView: View {
    @State var agents: [DeviceAgent] = []
    @State var animation_amount : CGFloat = 1
    @State var device_filter = ""
    @State var bg_color = Color.gray.opacity(0.4)
    @State var card_font_color = Color.white
    @State var show_sheet = false
    @State var sheet_content = DeviceAgent(MachineID: "", AgentID: 0, DeviceGuid: "", FolderID: 0, CustomerID: 0, CustomerName: "", AgentName: "", SystemName: "", MachineName: "", DomainName: "", CurrentLoggedUsers: "", ComputerDescription: "", Monitored: true, LastPatchManagementReceived: "", AgentVersion: "", Favorite: true, ThresholdID: 0, MonitoredAgentID: 0, Created: "", Modified: "", Online: true, ReportedFromIP: "", AppViewUrl: "", Motherboard: "", Processor: "", Memory: 0, Display: "", Sound: "", ProcessorCoresCount: 0, SystemDrive: "", ProcessorClock: "", Vendor: "", VendorSerialNumber: "", VendorBrandModel: "", ProductName: "", MacAddresses: [""], IpAddresses: [""], OS: "", OSType: "", WindowsSerialNumber: "", Office: "", OfficeSP: "", OfficeOEM: false, OfficeSerialNumber: "", OSNum: 0.0, LastRebootTime: "", OSVersion: "", OSBuild: "", OfficeFullVersion: "", LastLoginUser: "" )
    @State var columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        VStack{
            Spacer()
            HStack{
                TextField("Search By Username", text: $device_filter)
                    .padding()
                    .background(.regularMaterial)
                    .onChange(of: device_filter) { newValue in
                        if device_filter.count >= 3 {
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
                if device_filter.count > 2 {
                    Button {
                        device_filter = ""
                    } label: {
                        Text("Clear")
                    }
                }
            }.padding(.horizontal, 10)
        ScrollView(showsIndicators: true){

            LazyVGrid(columns: getDeviceOrientation() == "Landscape" ? gridColumns(columns: 4) : gridColumns(columns: 2)) {
                ForEach(agents, id:\.self) { ag in
                        if device_filter.count < 1 || ag.CurrentLoggedUsers!.contains(device_filter) {
                            NavigationLink {
                                AgentDetailsView(Agent: ag)
                            } label: {
                                ZStack(alignment: .leading){
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(ag.Online! ? Color("light_green") : .gray.opacity(0.45))
                                   
                                    Image(ag.OS != nil && ag.OS!.contains("Windows") ? "windows.logo" : "mac.logo")
                                        .resizable()
                                        .scaledToFit()
                                        .padding()
                                        .opacity(0.25)
                                    VStack{
                                        HStack{
                                            VStack(alignment: .leading, spacing: 3){
                                                Text("\(ag.AgentName)")
                                                    .fontWeight(.bold)
                                                    .padding(.bottom, 5)
                                                Text(getLoggedInUser(user:  ag.CurrentLoggedUsers!))
                                                    .fontWeight(.semibold)
                                            }
                                            .padding()
                                            .foregroundColor(ag.Online! ? Color.white : .gray)
                                            Spacer()
                                        }
                                    }
                                    .padding()
                                }
                                .cornerRadius(10)
                                .background(Material.ultraThinMaterial)
                            }
                        }
                    }
            }
            .onAppear {
                fetchAgents()
            }
            .navigationTitle("Device Agents")
            .sheet(isPresented: $show_sheet) {
                if (sheet_content.AgentName.count) > 1 {
                    Text("Wait \(sheet_content.AgentName ?? "Loading")")
                } else {
                    Text("UGH")
                }
            }.onAppear {
                print("AFG \(sheet_content.AgentName)")
            }
        }

        }
    }
    private func fetchAgents() {
            guard let url = URL(string: "https://app.atera.com/api/v3/agents") else {
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
//                    print("SKR \(String(describing: skr))")
                    guard let jsonData = skr!.data(using: .utf8) else {
                                print("Failed to convert JSON string to data.")
                                return
                            }

                            let decoder = JSONDecoder()
                            do {
                                let response = try decoder.decode(AgentResponse.self, from: jsonData)
                                agents = response.items
                            } catch {
                                print("Failed to decode JSON data: \(error)")
                            }
                        }
                
            }.resume()
        }
}

struct AgentView_Preview: PreviewProvider {
    static var previews: some View {
        AgentsView()
    }
}
