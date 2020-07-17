//
//  GameViewController.swift
//  MaterialTests
//
//  Created by Julian Arias Maetschl on 17-07-20.
//  Copyright © 2020 Maetschl. All rights reserved.
//

import SceneKit
import SpriteKit
import QuartzCore

class GameViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        let scene = SCNScene(named: "art.scnassets/scene.scn")!
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
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
        
        // retrieve the ship node
        let ship = scene.rootNode.childNode(withName: "ship", recursively: true)!
        ship.removeFromParentNode()
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = NSColor.black

        setupObjects(scene)
    }

    func setupObjects(_ scene: SCNScene) {

        var position: CGFloat = 0

        let planeWithColor = planeWith(diffuseContent: NSColor.green)
        planeWithColor.position.x = position
        scene.rootNode.addChildNode(planeWithColor)

        position += 1

        let image = NSImage(named: "texture")
        let planeWithImage = planeWith(diffuseContent: image)
        planeWithImage.position.x = position
        scene.rootNode.addChildNode(planeWithImage)

        position += 1

        let texture = SKTexture(imageNamed: "texture")
        let planeWithSKTexture = planeWith(diffuseContent: texture)
        planeWithSKTexture.position.x = position
        scene.rootNode.addChildNode(planeWithSKTexture)

        let imageDog = NSImage(named: "dog")
        let planeWithImageDog = planeWith(diffuseContent: imageDog)
        planeWithImageDog.position.x = 1
        planeWithImageDog.position.y = -1
        scene.rootNode.addChildNode(planeWithImageDog)

        let textureDog = SKTexture(imageNamed: "dog")
        let planeWithSKTextureDog = planeWith(diffuseContent: textureDog)
        planeWithSKTextureDog.position.x = 2
        planeWithSKTextureDog.position.y = -1
        scene.rootNode.addChildNode(planeWithSKTextureDog)

    }

    func planeWith(diffuseContent: Any?) -> SCNNode {
let plane = SCNPlane(width: 1, height: 1)
plane.firstMaterial?.diffuse.contents = diffuseContent
        let planeNode = SCNNode(geometry: plane)
        return planeNode
    }

}
