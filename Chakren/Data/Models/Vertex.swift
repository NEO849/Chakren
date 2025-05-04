//
//  Vertex.swift
//  Chakren
//
//  Created by Michael Fleps on 04.05.25.
//

import simd

/// Struktur und Definition für Vertex-Daten (// Position in Clipspace, Farbe pro Vertex, Texturkoordinaten für Effekte)
struct Vertex {
    var position: SIMD2<Float>
    var color: SIMD4<Float>
    var uv: SIMD2<Float>
}

let vertices: [Vertex] = [
    Vertex(position: [-0.5, -0.5], color: [1, 0, 0, 1], uv: [0, 0]),
    Vertex(position: [ 0.5, -0.5], color: [0, 1, 0, 1], uv: [1, 0]),
    Vertex(position: [-0.5,  0.5], color: [0, 0, 1, 1], uv: [0, 1]),
    Vertex(position: [ 0.5,  0.5], color: [1, 1, 0, 1], uv: [1, 1]),
]
