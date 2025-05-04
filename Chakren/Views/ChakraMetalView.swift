//
//  ChakraMetalView.swift
//  Chakren
//
//  Created by Michael Fleps on 03.05.25.
//

import SwiftUI
import MetalKit

/// UIViewRepresentable für die Einbindung von MetalKit in SwiftUI
struct ChakraMetalView: UIViewRepresentable {
    @EnvironmentObject var chakraVM: ChakraViewModel

    // MARK: - Coordinator, Kommunikation mit dem Renderer
    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: chakraVM)
    }

    // MARK: - Erstellt die MTKView mit zugewiesenem Renderer
    func makeUIView(context: Context) -> MTKView {
        let mtkView = MTKView()
        mtkView.device = MTLCreateSystemDefaultDevice()
        mtkView.delegate = context.coordinator.renderer
        mtkView.clearColor = MTLClearColorMake(0, 0, 0, 1)  // Schwarzer Hintergrund
        mtkView.framebufferOnly = false // Dadurch Shader-Output
        mtkView.drawableSize = mtkView.frame.size

        // Initialisiert Renderer und setzt ihn als Delegate
        let renderer = MetalRenderer(mtkView: mtkView)
        context.coordinator.renderer = renderer
        mtkView.delegate = renderer

        return mtkView
    }

    // MARK: - UIView Update
    func updateUIView(_ uiView: MTKView, context: Context) {
        guard let chakra = chakraVM.selectedChakra else { return }

        // Konvertiert Farbwerte für Metal
        let colorComponents = chakra.colorComponents.map { Float($0) }
        let metalColor = SIMD4<Float>(colorComponents)

        // Aktualisiert Renderer-Parameter
        context.coordinator.renderer?.updateChakra(
            color: metalColor,
            energy: Float(chakra.energyLevel))
    }

    // MARK: - Coordinator Class
    class Coordinator {
        var renderer: MetalRenderer?
        var viewModel: ChakraViewModel

        init(viewModel: ChakraViewModel) {
            self.viewModel = viewModel
        }
    }
}

#Preview {
    ChakraMetalView()
        .environmentObject(ChakraViewModel())
        .frame(width: 300, height: 300)
}
