//
//  ChakraSelectorView.swift
//  Chakren
//
//  Created by Michael Fleps on 04.05.25.
//

import SwiftUI

/// Auswahlansicht für alle 7 Chakren
struct ChakraSelectorView: View {
    @EnvironmentObject var viewModel: ChakraViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(viewModel.chakras) { chakra in
                    ChakraButton(chakra: chakra) {
                        viewModel.selectedChakra = chakra
                    }
                }
            }
            .padding()
        }
    }
}

/// Ein einzelner auswählbarer Chakra-Button
struct ChakraButton: View {
    let chakra: Chakra
    var onSelect: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            Circle()
                .fill(
                    Color(
                        red: chakra.colorComponents[0],
                        green: chakra.colorComponents[1],
                        blue: chakra.colorComponents[2],
                        opacity: chakra.colorComponents[3]
                    )
                )
                .frame(width: 44, height: 44)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                )
            Text(chakra.name)
                .font(.caption2)
                .foregroundColor(.white)
        }
        .padding(6)
        .background(Color.black.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .onTapGesture(perform: onSelect)
    }
}

#Preview {
    ChakraSelectorView()
        .environmentObject(ChakraViewModel())
        .background(Color.black)
}
