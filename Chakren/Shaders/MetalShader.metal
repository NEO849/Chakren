//
//  ChakraShader.metal
//  Chakren
//
//  Created by Michael Fleps on 03.05.25.
//


#include <metal_stdlib>
using namespace metal;

// Struktur für Vertex-Eingaben mit UV-Koordinaten
struct VertexIn {
    float2 position [[attribute(0)]];
    float4 color    [[attribute(1)]];
    float2 uv       [[attribute(2)]];
};

// Struktur für Vertex-Ausgaben mit UV-Koordinaten
struct VertexOut {
    float4 position [[position]];
    float4 color;
    float2 uv;
};

// Uniforms, um externe Daten (Zeit, Auflösung, Farbe) an Shader zu übergeben
struct Uniforms {
    float4 color;        // Chakra-Farbe (vom Benutzer gewählt)
    float time;          // Zeit in Sekunden für Animationen
    float2 resolution;   // Auflösung des Render-Ziels (für Normalisierung)
    float energyLevel;   // Energie-Level des Chakras [0..1] zur Steuerung von Effekten
};

// Vertex Shader für Rotation + Vorbereitung der UV-Koordinaten
vertex VertexOut chakra_vertex(VertexIn in [[stage_in]], constant Uniforms &u [[buffer(1)]]) {
    VertexOut out;
    float angle = u.time * 1.2;
    float c = cos(angle);
    float s = sin(angle);

    // Kreis-Rotation
    float2 rotated = float2(
        in.position.x * c - in.position.y * s,
        in.position.x * s + in.position.y * c
    );

    // Normalisierte UV-Koordinaten (von -1 bis 1 -> auf 0 bis 1)
    out.uv = rotated * 0.5 + 0.5;

    out.position = float4(rotated, 0.0, 1.0);
    out.color = in.color * u.color;
    return out;
}

// Fragment Shader für visuelle Effekte (Aura, Puls, Schatten)
fragment float4 chakra_fragment(VertexOut in [[stage_in]],
                                constant Uniforms& u [[buffer(0)]]) {

    // UV -> Zentrum auf (0,0)
    float2 uv = in.uv * 2.0 - 1.0;
    float dist = length(uv); // Abstand vom Mittelpunkt

    // Wellenrotation
    float angle = atan2(uv.y, uv.x);
    angle += 0.4 * sin(u.time + dist * 8.0);
    float radius = dist;
    uv = float2(cos(angle), sin(angle)) * radius;

    // Aura: flimmert mit Energie-Level
    float aura = smoothstep(0.5, 0.2, dist) * (0.4 + 0.6 * sin(u.time * 4.0 * u.energyLevel));

    // Puls: abhängig von Energie-Level
    float pulse = 0.2 + 0.6 * sin(u.time * 2.0) * u.energyLevel;

    // Schatten außen
    float shadow = smoothstep(0.95, 0.6, dist);

    float alpha = (1.0 - dist) * 0.7 + aura + pulse;
    alpha *= shadow;
    alpha = clamp(alpha, 0.0, 1.0);

    return float4(u.color.rgb, alpha);
}
