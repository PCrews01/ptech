//
//  AgentDetailsView.swift
//  pockettech
//
//  Created by Paul Crews on 6/8/23.
//

import SwiftUI

struct AgentDetailsView: View {
    @State var Agent:DeviceAgent
    @State var animation_amount: CGFloat = 0.5
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                VStack(alignment:.leading){
                    Text(Agent.AgentName)
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .padding(.horizontal, 5)
                    Text(getLoggedInUser(user:Agent.CurrentLoggedUsers!))
                        .font(.title2)
                }
                Spacer()
                Text(Agent.Online! ? "🟢" : "🔴" )
            }
            .padding(.horizontal, 5)
            Divider()
            ScrollView(showsIndicators: false) {
                VStack{
                    let t = Mirror(reflecting: Agent)
                        .children.map { "\($0.label!)" }
                    let k = Mirror(reflecting: Agent)
                        .children.map { "\($0.value)" }
                    
                    ForEach(t.indices, id: \.self){ index in
                        let label = t[index]
                        let value = k[index]
                            HStack{
                                Text(label)
                                    .fontWeight(.semibold)
                                Spacer()
                                Text(formatValue(value))
                            }
                            .padding(.vertical, 3)
                        Divider()
                    }
                }
            }
        }
    }
    private func formatValue(_ value: Any) -> String {
        if value as! String != "nil"{
            let optionale = value as? String
            if let optionalValue = optionale as? OptionalProtocol{
                if let unwrappedValue = optionalValue.getOptionalValue() {
                    return String(describing: unwrappedValue).replacingOccurrences(of: "Optional", with: "")
                        .dropFirst()
                        .replacingOccurrences(of: "\"", with: "")
                        .replacingOccurrences(of: ")", with: "")
                }
            }
            return "N/A"
        } else {
            return "N/A"
        }
    }
}

protocol OptionalProtocol {
    func getOptionalValue() -> Any?
}

extension Optional: OptionalProtocol {
    func getOptionalValue() -> Any? {
        return self
    }
}
struct AgentDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        var demo = DeviceAgent(MachineID: "MachineIDs", AgentID: 000, DeviceGuid: "DeviceGuid", FolderID: 0000, CustomerID: 000, CustomerName: "", AgentName: "AgentName", SystemName: "SystemName", MachineName: "MachineName", DomainName: "DomainName", CurrentLoggedUsers: "CurrentLoggedUsers", ComputerDescription: "ComputerDescription", Monitored: true, LastPatchManagementReceived: "LastPatchManagementReceived", AgentVersion: "AgentVersion", Favorite: true, ThresholdID: 0000, MonitoredAgentID: 0000, Created: "Created", Modified: "Modified", Online: true, ReportedFromIP: "ReportedFromIP", AppViewUrl: "AppViewUrl", Motherboard: "Motherboard", Processor: "Processor", Memory:000, Display: "Display", Sound: "Sound", ProcessorCoresCount: 003, SystemDrive: "SystemDrive", ProcessorClock: "ProcessorClock", Vendor: "Vendor", VendorSerialNumber: "VendorSerialNumber", VendorBrandModel: "VendorBrandModel", ProductName: "ProductName", MacAddresses: ["MacAddresses"], IpAddresses:[ "IpAddresses"], OS: "OS", OSType: "OSType", WindowsSerialNumber: "WindowsSerialNumber", Office: "Office", OfficeSP: "OfficeSP", OfficeOEM: false, OfficeSerialNumber: "OfficeSerialNumber", OSNum: 000, LastRebootTime: "LastRebootTime", OSVersion: "OSVersion", OSBuild: "OSBuild", OfficeFullVersion: "OfficeFullVersion", LastLoginUser: "LastLoginUser")
        AgentDetailsView(Agent: demo)
    }
}
