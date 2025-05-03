//
//  Chakra.swift
//  Chakren
//
//  Created by Michael Fleps on 03.05.25.
//

import Foundation
import simd

/// Chakra Model. SIMD4<Float> für die Farbe, da dies direkt mit Metal kompatibel ist.
struct Chakra: Codable, Identifiable {
    let id: Int
    let name: String
    let colorComponents: [Double] // [R, G, B, A]
    let energyLevel: Double
    
    // Computed Property für SIMD4
    var simdColor: SIMD4<Float> {
        SIMD4<Float>(
            Float(colorComponents[0]),
            Float(colorComponents[1]),
            Float(colorComponents[2]),
            Float(colorComponents[3])
        )
    }
    
    // JSON-Anpassungen
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case colorComponents = "color"
        case energyLevel
    }
}
