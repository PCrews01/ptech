//
//  Scene.swift
//  pockettech
//
//  Created by Paul Crews on 6/9/23.
//
import SwiftUI
import Foundation
import GoogleSignIn

struct MyApp: App {
    var body: some Scene{
        WindowGroup{
            ContentView()
                .onAppear(perform: {
                    print("Ready")
                    GIDSignIn.sharedInstance.restorePreviousSignIn{ user, error in
                        if let err = error {
                            print("Error \(err)")
                            return
                        }
                    }
                })
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}
