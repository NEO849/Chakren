//
//  ChakraDetailView.swift
//  Chakren
//
//  Created by Michael Fleps on 04.05.25.
//

import SwiftUI

/// Detailansicht für ein einzelnes Chakra mit MetalKit-Visualisierung
struct ChakraDetailView: View {
    @EnvironmentObject var viewModel: ChakraViewModel

    var body: some View {
        VStack(spacing: 24) {
            // Chakra-Metal-Visualisierung (animierter Kreis)
            ChakraMetalView()
                .frame(width: 220, height: 220)
                .cornerRadius(110)
                .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 6)

            // Chakra-Infos anzeigen
            if let chakra = viewModel.selectedChakra {
                VStack(spacing: 10) {
                    Text(chakra.name)
                        .font(.title2)
                        .bold()

                    Text(chakra.description)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    // Energie-Level Slider zur Live-Anpassung
                    VStack(spacing: 4) {
                        Text("Energie-Level: \(Int(chakra.energyLevel * 100))%")
                            .font(.caption)
                            .foregroundColor(.gray)

   
                    }
                    .padding(.horizontal)
                }
            } else {
                Text("Kein Chakra ausgewählt")
            }
        }
        .padding()
        .navigationTitle("Chakra Details")
    }
}

#Preview {
    ChakraDetailView()
        .environmentObject(ChakraViewModel())
}
