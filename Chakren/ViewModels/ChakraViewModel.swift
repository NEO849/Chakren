//
//  ChakraViewModel.swift
//  Chakren
//
//  Created by Michael Fleps on 03.05.25.
//

import Foundation
import Combine
import SwiftUI

/// Logikschicht zwischen Model (Chakra) und View.
class ChakraViewModel: ObservableObject {
    @Published var chakras: [Chakra] = []
    @Published var selectedChakra: Chakra?
    
    init() {
        loadChakras()
    }
    
    /// Lädt die Chakren über das Repository und setzt das erste als aktiv
    func loadChakras() {
        do {
            let result = try ChakraRepository.fetchChakras()
            chakras = result
            selectedChakra = result.first
        } catch {
            print("Fehler beim Laden der Chakren: \(error.localizedDescription)")
        }
    }
    
    /// Aktualisiert das Energielevel eines bestimmten Chakras und setzt es als aktiv.
    func updateEnergy(for chakraId: Int, newValue: Double) {
        if let index = chakras.firstIndex(where: { $0.id == chakraId }) {
            chakras[index].energyLevel = newValue
            selectedChakra = chakras[index] // Triggert UI
        }
    }

    /// Setzt das aktiv angezeigte Chakra über ID
    func selectChakra(by id: Int) {
        selectedChakra = chakras.first(where: { $0.id == id })
    }
}
