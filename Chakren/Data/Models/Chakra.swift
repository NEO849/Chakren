//
//  Chakra.swift
//  Chakren
//
//  Created by Michael Fleps on 03.05.25.
//

import Foundation

struct Chakra: Identifiable, Codable {
    let id: Int                      // Chakra-Nummer (1-7)
    let name: String                 // Name (z.B. "Wurzelchakra")
    let description: String          // Beschreibung
    var colorComponents: [Double]    // RGBA-Werte als Array (0.0 - 1.0)
    var frequency: Double            // Optionale Frequenz (z.B. 396 Hz)
    var energyLevel: Double          // Energie-Level (1-10)
    
    static func == (lhs: Chakra, rhs: Chakra) -> Bool {
        lhs.id == rhs.id
    }
}
