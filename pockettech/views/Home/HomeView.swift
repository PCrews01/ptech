//
//  HomeView.swift
//  pockettech
//
//  Created by Paul Crews on 6/10/23.
//

import SwiftUI



let demo_alerts = AteraAlert(
AlertID: 0,
Code: 0,
Source: "",
Title: "",
Severity: "",
Created: "",
SnoozedEndDate: "",
DeviceGuid: "",
AdditionalInfo: "",
Archived: false,
AlertCategoryID: "",
ArchivedDate: "",
TicketID: "",
AlertMessage: "",
DeviceName: "",
CustomerID: 0,
CustomerName: "",
FolderID: "",
PollingCyclesCount: 0)

struct HomeView: View {
    @State var stack_height:CGFloat = 0
    @State var alerts: [AteraAlert] = []
    @State var animating = false
    @State var scaler: CGFloat = 1
    @Binding var show_sheet : Bool 
    @State var selected_alert : AteraAlert = demo_alerts
    
    let animation: Animation = Animation.linear(duration: 0.8).repeatForever(autoreverses: true)
    var body: some View {
        ZStack{
            Image("mountain")
                .resizable()
                .edgesIgnoringSafeArea(.vertical)
            VStack{
                NavigationLink {
                    LoginView()
                } label: {
                    HStack{
                        Spacer()
                        Image(systemName: "person.circle")
                            .frame(width: 30, height: 30)
                    }
                    .padding()
                }
                Spacer()
                VStack{
                    VStack(alignment: .center){
                        Text("Pocket Tech")
                            .transition(.slide)
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                    }.frame(height: 600)
                        .frame(width: UIScreen.main.bounds.width - 20, height: 50)
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                    ScrollView{
                        LazyVStack{
                            ForEach(alerts, id:\.self){
                                alert in
                                    HStack{
                                        VStack(alignment: .leading){
                                            Text(alert.DeviceName)
                                                .fontWeight(.semibold)
                                            Text(alert.AlertMessage)
                                                .multilineTextAlignment(.leading)
                                                .lineLimit(3)
                                        }
                                        Spacer()
                                        switch alert.Severity{
                                        case "Warning":
                                            Text("‼️")
                                        case "Critical":
                                            Text("🚨")
                                                .font(.largeTitle)
                                                .scaleEffect(animating ? 1.5 : 1)
                                                .onAppear {
                                                    withAnimation(animation){
                                                        animating.toggle()
                                                    }
                                                }
                                        case "Information":
                                            Text("❗️")
                                        default:
                                            Text("⭕️")
                                        }
                                    }
                                    .onTapGesture {
                                        setupSheet(alert:alert)
                                            show_sheet = true
//
                                    }
                                    .padding()
                                    .background(RoundedRectangle(
                                        cornerRadius: 12,
                                        style: .continuous
                                    )
                                        .stroke(alert.Severity == "Warning" ? Color("dark_green") : alert.Severity == "Critical" ? .red : Color("light_green"), lineWidth: animating ? 5: 2)
                                    )
                                    .foregroundColor(Color.primary)
                                    .background(.ultraThinMaterial)
                                    .frame(width: 400)
                                    .cornerRadius(12)
                                    .shadow(radius: 2.5)
                                    .padding(.bottom, 5)
                                    .sheet(isPresented: $show_sheet, onDismiss: getAlerts) {
                                        AlertView(alert: $selected_alert, show_sheet: $show_sheet)
                                    }
                                }
                        }
                    }
                }
            }.refreshable(action: {
                    withAnimation(.easeOut(duration: 0.8)){
                        stack_height = 600
                        getAlerts()
                    }
                    withAnimation(animation){
        //                animating.toggle()
                    }
            })
        }.onAppear {
            withAnimation(.easeOut(duration: 0.8)){
                stack_height = 600
                getAlerts()
            }
            withAnimation(animation){
//                animating.toggle()
            }
        }
    }
    func setupSheet(alert: AteraAlert){
        selected_alert = alert
    }
    
    func getAlerts(){
            guard let url = URL(string: "https://app.atera.com/api/v3/alerts") else {
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
                        let response = try decoder.decode(AlertResponse.self, from: jsonData)
                        alerts = response.items
                    } catch {
                        print("Failed to decode JSON data: \(error)")
                    }
                }
                
            }.resume()
        }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
