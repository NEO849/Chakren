//
//  ChakraViewModel.swift
//  Chakren
//
//  Created by Michael Fleps on 03.05.25.
//

import Foundation
import Combine
import SwiftUI

/// Verwaltet alle Chakren und das aktuell aktive Chakra.
class ChakraViewModel: ObservableObject {
    @Published var chakras: [Chakra] = []
    @Published var selectedChakra: Chakra?
    
    init() {
        loadChakras()
    }
    
    // MARK: - Lädt die Chakra-Daten und aktualisiert den Zustand
    func loadChakras() {
        do {
            let loadedChakras = try ChakraRepository.fetchChakras()
            self.chakras = loadedChakras
            self.selectedChakra = loadedChakras.first
        } catch {
            print("Fehler beim Laden: \(error.localizedDescription)")
        }
    }

    /// Wechselt zum gewünschten Chakra per ID
    func selectChakra(by id: Int) {
        selectedChakra = chakras.first(where: { $0.id == id })
    }
}
