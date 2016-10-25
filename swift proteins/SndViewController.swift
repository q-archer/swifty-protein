//
//  SndViewController.swift
//  swift proteins
//
//  Created by Melvin MOUSTAID on 10/19/16.
//  Copyright © 2016 Melvin MOUSTAID. All rights reserved.
//

import UIKit
import SceneKit
import Social

class SndViewController: UIViewController {

    var ligand : String?
    var scnView : SCNView?
    @IBOutlet weak var elementLabel: UILabel!
    
    
    override func viewDidLoad() {
        self.scnView = self.view as? SCNView

        
        if let l = ligand {
            load(l)
        }
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(SndViewController.didTap(_:)))
        self.view.addGestureRecognizer(tapGR)
    }
    
    @IBOutlet weak var descriptionLabel: UILabel!
    func load(ligand: String) {
        let first = "https://files.rcsb.org/ligands/view/"
        let last = "_ideal.pdb"
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let url = NSURL(string: first + ligand + last)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {
            (data, response, error) in
            
            if error == nil {
                if let response = response as? NSHTTPURLResponse {
                    
                    if response.statusCode >= 200 && response.statusCode <= 299 {

                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let urlContent = NSString(data: data!, encoding: NSASCIIStringEncoding) as NSString!
                            
                            var sentenceLines:[String] = []
                            let string = urlContent as String
                            string.enumerateLines { sentenceLines.append($0.line) }
                            
                            self.scnView!.scene = PrimitivesScene(file: sentenceLines)
                            
                            let cameraNode = SCNNode()
                            let camera = SCNCamera()
                            cameraNode.camera = camera
                            self.scnView!.scene!.rootNode.addChildNode(cameraNode)
                            cameraNode.position = SCNVector3(x: 0, y: 0, z: 35)
                            
                            self.scnView?.scene?.background.contents = UIImage(named: "test.jpg")
                            self.scnView!.backgroundColor = UIColor.whiteColor()
                            self.scnView!.autoenablesDefaultLighting = true
                            self.scnView!.allowsCameraControl = true
                            
                            self.descriptionLabel.text = "Ligand number " + ligand
                        })
                        
                    } else {
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let alertController = UIAlertController(title: "Error", message: "Can't load Ligand: \(ligand)", preferredStyle: .Alert)
                            let defaultAction = UIAlertAction(title: "GOTCHA", style: .Default, handler: nil)
                            alertController.addAction(defaultAction)
                            self.presentViewController(alertController, animated: true, completion: nil)
                        })
                        

                    }
                }
                
            } else {
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let alertController = UIAlertController(title: "Error", message: "Can't load Ligand", preferredStyle: .Alert)
                    let defaultAction = UIAlertAction(title: "GOTCHA", style: .Default, handler: nil)
                    alertController.addAction(defaultAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                })
            }
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        task.resume()
    }

    func didTap(tapGR: UITapGestureRecognizer) {
        let tapPoint = tapGR.locationInView(view)
        let hits = self.scnView!.hitTest(tapPoint, options: nil)
        
        if let tappedNode = hits.first?.node {
            elementLabel.hidden = false
            elementLabel.text = "Selected Element: " + tappedNode.ligand.name
        }

    }
    
    @IBAction func shareAction(sender: UIBarButtonItem) {
        let vc = UIActivityViewController(activityItems: [(self.scnView?.snapshot())!], applicationActivities: nil)
        self.presentViewController(vc, animated: true, completion: nil)
    }

    
}


