//
//  models.swift
//  pockettech
//
//  Created by Paul Crews on 5/27/23.
//

import Foundation

struct KnowledgeBase: Hashable, Codable{
    let KBID: Int?
    let items: [KBArticle]
    let totalItemCount: Int
    let page: Int
    let itemsInPage: Int
    let totalPages: Int
    let prevLink: String
    let nextLink: String
}

struct KBArticle: Hashable, Codable{
//    let ArticleID: Int
    let KBID: Int?
    let KBTimestamp: String
    let KBContext: String
    let KBProduct: String
    let KBRating_Yes: Int?
    let KBRating_No: Int?
    let KBRating_Views: Int?
    let KBLastModified: String?
    let KBIsPrivate: Bool?
    let KBStatus: Int?
    let KBPriority: Int?
    let KBKeywords: String?
    let KBAddress: String?
}
struct Ticket: Hashable, Codable {
   var TicketID: Int
     var TicketTitle: String
     var TicketNumber: String
     var TicketPriority: String
     var TicketImpact: String
     var TicketStatus: String
     var TicketSource: String
     var TicketType: String
     var EndUserID: Int
     var EndUserEmail: String
     var EndUserFirstName: String
     var EndUserLastName: String
     var EndUserPhone: String?
     var TicketResolvedDate: String?
     var TicketCreatedDate: String
     var TechnicianFirstCommentDate: String?
     var FirstResponseDueDate: String?
     var ClosedTicketDueDate: String?
     var FirstComment: String
     var LastEndUserComment: String
     var LastEndUserCommentTimestamp: String
     var LastTechnicianComment: String?
     var LastTechnicianCommentTimestamp: String?
     var OnSiteDurationSeconds: Int?
     var OnSiteDurationMinutes: Int?
     var OffSiteDurationSeconds: Int?
     var OffSiteDurationMinutes: Int?
     var OnSLADurationSeconds: Int?
     var OnSLADurationMinutes: Int?
     var OffSLADurationSeconds: Int?
     var OffSLADurationMinutes: Int?
     var TotalDurationSeconds: Int?
     var TotalDurationMinutes: Int?
     var CustomerID: Int
     var CustomerName: String
     var CustomerBusinessNumber: String?
     var TechnicianContactID: Int?
    var TechnicianFullName: String? = "unassigned"
    var TechnicianEmail: String? = "unassigned"
     var ContractID: Int?
}
struct TicketResponse: Codable{
    let items: [Ticket]
    let totalItemCount: Int
    let page: Int
    let itemsInPage: Int
    let totalPages: Int
    let prevLink: String
    let nextLink: String
}

struct DeviceAgent: Hashable, Codable{
    let MachineID: String?
    let AgentID: Int?
    let DeviceGuid: String?
    let FolderID: Int?
    let CustomerID: Int?
    let CustomerName: String?
    let AgentName: String
    let SystemName: String?
    let MachineName: String?
    let DomainName: String?
    let CurrentLoggedUsers: String?
    let ComputerDescription: String?
    let Monitored: Bool?
    let LastPatchManagementReceived: String?
    let AgentVersion: String?
    let Favorite: Bool?
    let ThresholdID: Int?
    let MonitoredAgentID: Int?
    let Created: String?
    let Modified: String?
    let Online: Bool?
    let ReportedFromIP: String?
    let AppViewUrl: String?
    let Motherboard: String?
    let Processor: String?
    let Memory: Int?
    let Display: String?
    let Sound: String?
    let ProcessorCoresCount: Int?
    let SystemDrive: String?
    let ProcessorClock: String?
    let Vendor: String?
    let VendorSerialNumber: String?
    let VendorBrandModel: String?
    let ProductName: String?
    let MacAddresses: [String]?
    let IpAddresses: [String]?
//    let HardwareDisks: NSObject?
    let OS: String?
    let OSType: String?
    let WindowsSerialNumber: String?
    let Office: String?
    let OfficeSP: String?
    let OfficeOEM: Bool?
    let OfficeSerialNumber: String?
    let OSNum: Float?
    let LastRebootTime: String?
    let OSVersion: String?
    let OSBuild: String?
    let OfficeFullVersion: String?
    let LastLoginUser: String?
}
struct AgentResponse: Codable{
    let items: [DeviceAgent]
    let totalItemCount: Int
    let page: Int
    let itemsInPage: Int
    let totalPages: Int
    let prevLink: String
    let nextLink: String
}

struct AteraAlert: Hashable, Codable{
    let AlertID: Int
    let Code: Int
    let Source: String
    let Title: String
    let Severity: String
    let Created: String
    let SnoozedEndDate: String?
    let DeviceGuid: String
    let AdditionalInfo: String?
    let Archived: Bool
    let AlertCategoryID: String
    let ArchivedDate: String?
    let TicketID: String?
    let AlertMessage: String
    let DeviceName: String
    let CustomerID: Int
    let CustomerName:String
    let FolderID: String?
    let PollingCyclesCount: Int? 
}

struct AlertResponse: Codable{
    let items: [AteraAlert]
    let totalItemCount: Int
    let page: Int
    let itemsInPage: Int
    let totalPages: Int
    let prevLink: String
    let nextLink: String
}
let demo_agent: DeviceAgent = DeviceAgent(MachineID: "MID", AgentID: 0, DeviceGuid: "DG", FolderID: 0, CustomerID: 0, CustomerName: "CN", AgentName: "AN", SystemName: "SN", MachineName: "MN", DomainName: "DM", CurrentLoggedUsers: "CLU", ComputerDescription: "CD", Monitored: false, LastPatchManagementReceived: "LPMR", AgentVersion: "AV", Favorite: false, ThresholdID: 0, MonitoredAgentID: 0, Created: "CTD", Modified: "MDFD", Online: false, ReportedFromIP: "RIP", AppViewUrl: "AVU", Motherboard: "MB", Processor: "PRC", Memory: 9, Display: "DI", Sound: "sounf", ProcessorCoresCount: 0, SystemDrive: "sg", ProcessorClock: "PC", Vendor: "VD", VendorSerialNumber: "VSN", VendorBrandModel: "VBM", ProductName: "PN", MacAddresses: ["MA"], IpAddresses: ["IP"], OS: "OS", OSType: "OST", WindowsSerialNumber: "WSN", Office: "OFC", OfficeSP: "OSPC", OfficeOEM: false, OfficeSerialNumber: "OSN", OSNum: 0, LastRebootTime: "LBT", OSVersion: "OSV", OSBuild: "OSB", OfficeFullVersion: "OOFV", LastLoginUser: "LIU")
let demo_ticket: Ticket =  Ticket(
    TicketID: 0,
    TicketTitle: "",
    TicketNumber: "",
    TicketPriority: "",
    TicketImpact: "",
    TicketStatus: "",
    TicketSource: "",
    TicketType: "",
    EndUserID: 0,
    EndUserEmail: "",
    EndUserFirstName: "",
    EndUserLastName: "",
    EndUserPhone: "",
    TicketResolvedDate: "",
    TicketCreatedDate: "",
    TechnicianFirstCommentDate: "",
    FirstResponseDueDate: "",
    ClosedTicketDueDate: "",
    FirstComment: "",
    LastEndUserComment: "",
    LastEndUserCommentTimestamp: "",
    LastTechnicianComment: "",
    LastTechnicianCommentTimestamp: "",
    OnSiteDurationSeconds: 0,
    OnSiteDurationMinutes: 0,
    OffSiteDurationSeconds: 0,
    OffSiteDurationMinutes: 0, 
    OnSLADurationSeconds: 0,
    OnSLADurationMinutes: 0,
    OffSLADurationSeconds: 0,
    OffSLADurationMinutes: 0,
    TotalDurationSeconds: 0,
    TotalDurationMinutes: 0,
    CustomerID: 0,
    CustomerName: "",
    CustomerBusinessNumber: "",
    TechnicianContactID: 0,
    ContractID: 0)
let demo_alert = AteraAlert(
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
