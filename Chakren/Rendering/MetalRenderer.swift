//
//  MetalRenderer.swift
//  Chakren
//
//  Created by Michael Fleps on 03.05.25.
//

import Foundation
import MetalKit
import simd

final class MetalRenderer: NSObject, MTKViewDelegate {
    // MARK: - Interne Struktur
    struct Uniforms {
        var color: SIMD4<Float>
        var time: Float
        var resolution: SIMD2<Float>
        var energy: Float
    }

    // MARK: - Private Properties
    private let device: MTLDevice
    private let commandQueue: MTLCommandQueue
    private var pipelineState: MTLRenderPipelineState!
    private var vertexBuffer: MTLBuffer!
    private var uniformBuffer: MTLBuffer!
    private var startTime: CFTimeInterval = CACurrentMediaTime()
    private var color: SIMD4<Float> = SIMD4<Float>(1, 1, 1, 1)
    private var energy: Float = 1.0

    // MARK: - Initialisierung
    init(mtkView: MTKView) {
        guard let device = mtkView.device else {
            fatalError("Metal-Gerät konnte nicht initialisiert werden")
        }
        self.device = device
        self.commandQueue = device.makeCommandQueue()!
        super.init()
        buildPipeline(view: mtkView)
        buildVertices()
        buildUniforms()
    }

    // MARK: - MTKViewDelegate
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let renderPassDescriptor = view.currentRenderPassDescriptor else { return }

        let currentTime = Float(CACurrentMediaTime() - startTime)

        var uniforms = Uniforms(
            color: color,
            time: currentTime,
            resolution: SIMD2(Float(view.drawableSize.width), Float(view.drawableSize.height)),
            energy: energy
        )
        memcpy(uniformBuffer.contents(), &uniforms, MemoryLayout<Uniforms>.stride)

        let commandBuffer = commandQueue.makeCommandBuffer()!
        let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!

        encoder.setRenderPipelineState(pipelineState)
        encoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        encoder.setVertexBuffer(uniformBuffer, offset: 0, index: 1)
        encoder.setFragmentBuffer(uniformBuffer, offset: 0, index: 0)

        encoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 6)

        encoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}

    func updateChakra(color: SIMD4<Float>, energy: Float) {
        self.color = color
        self.energy = energy
    }

    // MARK: - Setup-Funktionen
    private func buildPipeline(view: MTKView) {
        guard let library = device.makeDefaultLibrary() else {
            fatalError("Shader-Bibliothek fehlt")
        }
        let vertexFunc = library.makeFunction(name: "chakra_vertex")!
        let fragmentFunc = library.makeFunction(name: "chakra_fragment")!

        let vertexDescriptor = MTLVertexDescriptor()

        // Attribute(0): position (float2)
        vertexDescriptor.attributes[0].format = .float2
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0

        // Attribute(1): color (float4)
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].offset = MemoryLayout<SIMD2<Float>>.stride
        vertexDescriptor.attributes[1].bufferIndex = 0

        // Attribute(2): uv (float2)
        vertexDescriptor.attributes[2].format = .float2
        vertexDescriptor.attributes[2].offset = MemoryLayout<SIMD2<Float>>.stride + MemoryLayout<SIMD4<Float>>.stride
        vertexDescriptor.attributes[2].bufferIndex = 0

        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        vertexDescriptor.layouts[0].stepRate = 1
        vertexDescriptor.layouts[0].stepFunction = .perVertex

        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.vertexFunction = vertexFunc
        descriptor.fragmentFunction = fragmentFunc
        descriptor.vertexDescriptor = vertexDescriptor
        descriptor.colorAttachments[0].pixelFormat = view.colorPixelFormat

        pipelineState = try! device.makeRenderPipelineState(descriptor: descriptor)
    }

    private func buildVertices() {
        let vertices: [Vertex] = [
             Vertex(position: [-0.5, -0.5], color: [1, 0, 0, 1], uv: [0, 0]),
             Vertex(position: [ 0.5, -0.5], color: [0, 1, 0, 1], uv: [1, 0]),
             Vertex(position: [-0.5,  0.5], color: [0, 0, 1, 1], uv: [0, 1]),
             Vertex(position: [ 0.5, -0.5], color: [0, 1, 0, 1], uv: [1, 0]),
             Vertex(position: [ 0.5,  0.5], color: [1, 1, 0, 1], uv: [1, 1]),
             Vertex(position: [-0.5,  0.5], color: [0, 0, 1, 1], uv: [0, 1]),
         ]
         vertexBuffer = device.makeBuffer(bytes: vertices,
                                          length: vertices.count * MemoryLayout<Vertex>.stride,
                                          options: [])
     }

    private func buildUniforms() {
        uniformBuffer = device.makeBuffer(length: MemoryLayout<Uniforms>.stride, options: [])
    }
}
