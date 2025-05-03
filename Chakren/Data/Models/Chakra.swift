//
//  Chakra.swift
//  Chakren
//
//  Created by Michael Fleps on 03.05.25.
//

import Foundation
import simd

/// Das Chakra-Modell stellt ein Energiezentrum dar.
/// - Nutzt `SIMD4<Float>` für direkte Kompatibilität mit MetalKit Shadern.
struct Chakra: Codable, Identifiable {
    let id: Int
    let name: String
    var colorComponents: [Double]          // Farbkomponenten [R, G, B, A]
    var energyLevel: Double                // Energiezustand (0.0–1.0)

    /// Konvertiert die Farbdaten in einen Metal-kompatiblen Farbwert (Float-Vektor)
    var simdColor: SIMD4<Float> {
        SIMD4<Float>(
            Float(colorComponents[0]),
            Float(colorComponents[1]),
            Float(colorComponents[2]),
            Float(colorComponents[3])
        )
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case colorComponents = "color"   // Schlüssel in JSON-Datei
        case energyLevel
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Chakra, rhs: Chakra) -> Bool {
        lhs.id == rhs.id
    }
}
