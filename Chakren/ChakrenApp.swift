//
//  ChakrenApp.swift
//  Chakren
//
//  Created by Michael Fleps on 03.05.25.
//

import SwiftUI

@main
struct ChakrenApp: App {
    @StateObject private var chakraVM = ChakraViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(chakraVM) // global für alle Unterviews
        }
    }
}
