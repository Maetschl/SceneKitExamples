//
//  GameViewController.swift
//  CubeMaze
//
//  Created by Julián Arias on 8/21/19.
//  Copyright © 2019 maetschl. All rights reserved.
//

import SceneKit
import QuartzCore

class GameViewController: NSViewController {

    var cube: SCNNode?
    var scene: SCNScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        scene = SCNScene(named: "art.scnassets/ship.scn")!

        cube = scene.rootNode.childNode(withName: "box", recursively: false)
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 25)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = NSColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = false
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true

        // configure the view
        scnView.backgroundColor = NSColor.black
        
        // Add a click gesture recognizer
        let clickGesture = NSClickGestureRecognizer(target: self, action: #selector(handleClick(_:)))
        var gestureRecognizers = scnView.gestureRecognizers
        gestureRecognizers.insert(clickGesture, at: 0)

        let pan = NSPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        gestureRecognizers.insert(pan, at: 1)


        scnView.gestureRecognizers = gestureRecognizers
    }
    @objc
    func handlePan(_ gestureRecognizer: NSGestureRecognizer) {
        if let pan = gestureRecognizer as? NSPanGestureRecognizer {
            debugPrint(pan.buttonMask)
            debugPrint(pan.numberOfTouchesRequired)
            debugPrint(pan.velocity(in: self.view))
            let movement = pan.translation(in: self.view)
            let vectorMovement = SCNVector3(-movement.y*0.005, movement.x*0.005, 0.0)
            cube?.physicsBody?.applyTorque(SCNVector4(-movement.y*0.006, movement.x*0.005, 0.0, 1), asImpulse: true)
            scene.physicsWorld.updateCollisionPairs()
        }
    }
    @objc
    func handleClick(_ gestureRecognizer: NSGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are clicked
        let p = gestureRecognizer.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result = hitResults[0]
            
            // get its material
            let material = result.node.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                
                material.emission.contents = NSColor.black
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = NSColor.red
            
            SCNTransaction.commit()
        }
    }
}
