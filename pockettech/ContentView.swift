//
//  ContentView.swift
//  pockettech
//
//  Created by Paul Crews on 5/20/23.
//

import SwiftUI
import GoogleSignInSwift
import GoogleSignIn


struct ContentView: View {
    @State var logo_height:Int = 0
    @State var tab_opacity:Int = 0
    @State var selected_tab = 2
    @State var signed_in = GIDSignIn.sharedInstance.currentUser != nil ? true : false
    @State var selected_alert : AteraAlert = demo_alert
    @State var truthy = false
    var body: some View {
        NavigationView{
            VStack{
                if signed_in {
                        TabView(selection: $selected_tab) {
                            ChromebookView()
                                .tabItem {
                                    Image(systemName: "laptopcomputer")
                                }
                                .tag(0)
                            KBView()
                                .tabItem {
                                    Image(systemName: "text.book.closed")
                                }
                                .tag(1)
                            HomeView(show_sheet:$truthy)
                                .tabItem {
                                    Image(systemName: "house")
                                }
                                .tag(2)
                            AgentsView()
                                .tabItem {
                                    Image(systemName: "desktopcomputer")
                                }
                                .tag(3)
                            TicketsView()
                                .tabItem {
                                    Image(systemName: "ticket")
                                }
                                .tag(4)
                        }
                        .tint(Color("light_green"))
                        .onAppear {
                            UITabBar.appearance().scrollEdgeAppearance = UITabBarAppearance.init(idiom: .phone)
                        }
                    
                } else {
                    LoginView()
                }
            }
            .onAppear {
                print(GIDSignIn.sharedInstance.currentUser?.profile ?? "No profile")
                GIDSignIn.sharedInstance.restorePreviousSignIn(){ user, err in
                    print("Ret")
                    if let er = err {
                        print(" Error \(er.localizedDescription)")
                    }
                    if let user = user {
                        signed_in = true
                    } else {
                        print("Cannot do it")
                    }
                    
                }
            }
        }
    }
}
    

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(selected_alert: demo_alert)
    }
}
