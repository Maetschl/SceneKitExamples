//
//  GameViewController.swift
//  SKTextureOverPlanes
//
//  Created by Julian Arias Maetschl on 04-03-20.
//  Copyright © 2020 Maetschl. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import SpriteKit

class GameViewController: UIViewController {

    var scene: SCNScene?
    var counter = 0

    private func renderPlanes() {

        // MARK: - The example - https://stackoverflow.com/questions/60528301/reusing-a-single-skview-to-generate-multiple-sktextures-for-use-in-scenekit
        let myLabel = SKLabelNode(fontNamed: "Helvetica")
        myLabel.text = "Test!"
        myLabel.fontSize = 24
        myLabel.fontColor = SKColor.green
        myLabel.position = CGPoint(x: 50, y: 50)

        let skScene = SKScene(size: CGSize(width: 100, height: 100))
        skScene.addChild(myLabel)

        let geometry = SCNPlane(width: 5.0, height: 5.0)
        let plane = SCNNode(geometry: geometry)
        let planeMaterial = SCNMaterial()
        planeMaterial.diffuse.contents = skScene

        plane.position.y -= 3
        geometry.firstMaterial = planeMaterial

        scene?.rootNode.addChildNode(plane)

        // MARK: Some fancy
        // This is the power of get sceen for each one, are object reference and you can update 👍
        myLabel.run(SKAction.repeatForever(SKAction.sequence([SKAction.rotate(byAngle: .pi, duration: 2.0), SKAction.customAction(withDuration: 0.0, actionBlock: { (node, value) in
            self.counter += 1
            myLabel.text = String(self.counter)
        })])))

        // MARK: Option b)
        let geometry2 = SCNPlane(width: 5.0, height: 5.0)
        let plane2 = SCNNode(geometry: geometry2)
        let planeMaterial2 = SCNMaterial()
        planeMaterial2.diffuse.contents = SKView().texture(from: skScene)!
        geometry2.firstMaterial = planeMaterial2
        plane2.position.y += 3
        scene?.rootNode.addChildNode(plane2)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        scene = SCNScene(named: "art.scnassets/baseScene.scn")!
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene?.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene?.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene?.rootNode.addChildNode(ambientLightNode)

        renderPlanes()

        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.black

    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

}
