//
//  ContentView.swift
//  myMaskApp
//
//  Created by Valentina Inozemtseva on 27.06.2024.
//

import SwiftUI
import RealityKit
import ARKit

struct ContentView : View {
    @State private var isPresented: Bool = false
    var body: some View {
        ARViewContainer().edgesIgnoringSafeArea(.all)
            .alert("Face Tracking Unavailable", isPresented: $isPresented) {
                Button {
                    isPresented = false
                } label: {
                    Text("Okay")
                }
            } message: {
                Text("Face tracking requires an iPhone X or later.")
            }
            .onAppear {
                if !ARFaceTrackingConfiguration.isSupported {
                    isPresented = true
                }
            }
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)

        if let faceScene = try? PartyGlasses.loadFace() {
            arView.scene.anchors.append(faceScene)
        }

        let arConfig = ARFaceTrackingConfiguration()
        arView.session.run(arConfig)

        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
