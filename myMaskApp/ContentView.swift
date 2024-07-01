//
//  ContentView.swift
//  myMaskApp
//
//  Created by Valentina Inozemtseva on 27.06.2024.
//

import SwiftUI
import RealityKit
import ARKit


enum FaceMaskType: CaseIterable {
    case partyGlasses
    case coolGlasses
    case hiBubble
    case builderHat
    
    var modelName: String {
        switch self {
        case.coolGlasses:
            return "CoolGlasses"
        case .partyGlasses:
            return "PartyGlasses"
        case.hiBubble:
            return "HiBubble"
        case.builderHat:
            return "BuilderHat"
        }
    }
}


struct ContentView : View {
    @State private var isPresented: Bool = false
    @State private var selectedMaskType: FaceMaskType?
    var body: some View {
        ZStack {
            ARViewContainer(maskType: $selectedMaskType).edgesIgnoringSafeArea(.all)
               .alert("Face Tracking Unavailable", isPresented: $isPresented) {
                    Button {
                        isPresented = false
                    } label: {
                        Text("Okay")
                    }
                } message: {
                    Text("Face tracking requires an iPhone X or later.")
                }
            Color.clear.edgesIgnoringSafeArea(.all)
            VStack {
                Spacer(minLength: 200)
                
                HStack(alignment: .center) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(FaceMaskType.allCases, id: \.self) { maskType in
                                Button(action: {
                                    self.selectedMaskType = maskType
                                }) {
                                    Image(maskType.modelName)
                                       .resizable()
                                       .aspectRatio(contentMode:.fit)
                                       .frame(width: 80, height: 80, alignment: .center)
                                       .clipShape(Circle())
                                       .padding(15)
                                }
                            }
                        }
                    }
                }
            }
            .onAppear {
                if !ARFaceTrackingConfiguration.isSupported {
                    isPresented = true
                }
            }
        }}
    
    
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var maskType: FaceMaskType?

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)

        let arConfig = ARFaceTrackingConfiguration()
        arView.session.run(arConfig)

        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        if maskType?.modelName == "PartyGlasses" {
            if let faceScene = try? PartyGlasses.loadFace() {
                uiView.scene.anchors.removeAll()
                uiView.scene.anchors.append(faceScene)
            }
        }
        if maskType?.modelName == "CoolGlasses" {
            if let faceScene = try? CoolGlasses.loadScene() {
                uiView.scene.anchors.removeAll()
                uiView.scene.anchors.append(faceScene)
            }
        }
        if maskType?.modelName == "HiBubble" {
            if let faceScene = try? HiBubble.loadScene() {
                uiView.scene.anchors.removeAll()
                uiView.scene.anchors.append(faceScene)
            }
        }
        if maskType?.modelName == "BuilderHat" {
            if let faceScene = try? BuilderHat.loadScene() {
                uiView.scene.anchors.removeAll()
                uiView.scene.anchors.append(faceScene)
            }
        }
    }
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
