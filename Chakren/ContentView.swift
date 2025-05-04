//
//  ContentView.swift
//  Chakren
//
//  Created by Michael Fleps on 03.05.25.
//

import SwiftUI

/// Zeigt die Chakra-Auswahlleiste und die Metal-Animation.
struct ContentView: View {
    @EnvironmentObject var viewModel: ChakraViewModel

    var body: some View {
        VStack(spacing: 0) {
            // Auswahlleiste zur Auswahl des aktiven Chakras
            ChakraSelectorView()
                .padding(.top, 16)

            Spacer()

            // Anzeige des animierten Chakras via MetalKit
            ChakraMetalView()
                .frame(width: 300, height: 300)

            Spacer()

            // Anzeige des aktuellen Chakra-Namens
            if let selected = viewModel.selectedChakra {
                Text("Aktives Chakra: \(selected.name)")
                    .font(.title2)
                    .padding(.bottom)
            }
        }
        .background(Color.black.ignoresSafeArea())
        .foregroundColor(.white)
    }
}

#Preview {
    ContentView()
        .environmentObject(ChakraViewModel())
}
