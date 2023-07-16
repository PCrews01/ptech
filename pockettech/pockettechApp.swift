//
//  pockettechApp.swift
//  pockettech
//
//  Created by Paul Crews on 5/20/23.
//

import SwiftUI
import GoogleSignIn

@main
struct pockettechApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear{
                print("Ready")
                GIDSignIn.sharedInstance.restorePreviousSignIn{ user, error in
                    if let err = error {
                        print("Error \(err)")
                        return
                    }
                }
            }
            .onOpenURL { url in
                GIDSignIn.sharedInstance.handle(url)
            }
        }
    }
}
