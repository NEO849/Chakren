//
//  ChakraViewModel.swift
//  Chakren
//
//  Created by Michael Fleps on 03.05.25.
//

import Foundation
import Combine

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
            chakras =  try ChakraRepository.fetchChakras()
            selectedChakra = chakras.first
        } catch {
            print("Fehler beim fetchen der Chakren (Repo-Schicht): \(error.localizedDescription)")
        }
    }
    
    /// Aktualisiert das Energielevel eines bestimmten Chakras und setzt es als aktiv.
    func updateEnergy(for chakraId: Int, newValue: Double) {
        guard let index = chakras.firstIndex(where: { $0.id == chakraId }) else { return }
        chakras[index].energyLevel = newValue
        if chakras[index].id == selectedChakra?.id {
            selectedChakra = chakras[index] // Triggert UI
        }
    }
    
    /// Setzt das aktiv angezeigte Chakra über ID
    func selectChakra(by id: Int) {
        if let found = chakras.first(where: { $0.id == id }) {
            selectedChakra = found
        }
    }
}
