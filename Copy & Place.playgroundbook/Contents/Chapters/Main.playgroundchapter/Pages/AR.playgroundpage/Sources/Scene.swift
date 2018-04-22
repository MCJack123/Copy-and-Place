//
//  Scene.swift
//  ARKit Test
//
//  Created by Jack on 3/28/18.
//  Copyright © 2018 JackMacWindows. All rights reserved.
//

import SpriteKit
import ARKit

public class Scene: SKScene {
    
    public var lastHit: matrix_float4x4?
    
    public override func didMove(to view: SKView) {
        // Setup your scene here
    }
    
    public override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let sceneView = self.view as? ARSKView else {
            return
        }
        
        /* Static placement
        // Create anchor using the camera's current position
        if let currentFrame = sceneView.session.currentFrame {
            
            // Create a transform with a translation of 0.2 meters in front of the camera
            var translation = matrix_identity_float4x4
            translation.columns.3.z = -0.2
            let transform = simd_mul(currentFrame.camera.transform, translation)
            
            // Add a new anchor to the session
            let anchor = ARAnchor(transform: transform)
            
        }
        */
        let touchPos = touches.first!.location(in: nil)
        let hits = sceneView.hitTest(touchPos, types: .featurePoint)
        if hits.count > 0 /*&& hits[0].worldTransform != lastHit*/ {
            var w = 0
            if hits[0].worldTransform[0].w == 1 {
                w = 0
            } else if hits[0].worldTransform[1].w == 1 {
                w = 1
            } else if hits[0].worldTransform[2].w == 1 {
                w = 2
            } else if hits[0].worldTransform[3].w == 1 {
                w = 3
            }
            print("Hit anchor at (\(hits[0].worldTransform[w].x), \(hits[0].worldTransform[w].y), \(hits[0].worldTransform[w].z))")
            let anchor = ARAnchor(transform: hits[0].worldTransform)
            sceneView.session.add(anchor: anchor)
            //lastHit = hits[0].worldTransform
        } else {
            print("No hits")
        }
    }
}
