//
//  ChakraUniforms.swift
//  Chakren
//
//  Created by Michael Fleps on 04.05.25.
//

import simd

/// Wird an das Metal Shader-Programm übergeben
struct ChakraUniforms {
    var color: SIMD4<Float>
    var time: Float              
    var energyLevel: Float       // Einfluss auf z.B. Größe oder Glühen
    var frequency: Float         // Sinusmodulation
}
