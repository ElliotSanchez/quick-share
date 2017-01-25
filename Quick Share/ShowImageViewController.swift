//
//  ShowImageViewController.swift
//  Quick Share
//
//  Created by hostname on 10/31/16.
//  Copyright © 2016 notungood. All rights reserved.
//

import UIKit
import Photos
import Social

// CommunicationControllerSharing is a protocol implemented in ShareImageVC
class ShowImageViewController: UIViewController, UIDocumentInteractionControllerDelegate, CommunicationControllerSharing {

    // View of the full sized image we are sharing
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func tapBackArrowButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBOutlet weak var bottomShareButton: UIButton!
    
    @IBAction func tapBottomShareButton(_ sender: UIButton) {
        // hide sharing button that's covered by modal ShareImageVC
        sender.isHidden = true
        
        // set self as delegate for when modal VC is dismissed
        // see ShareImageVC comments for link to Stack overflow source
        
        performSegue(withIdentifier: "shareImageSegue", sender: nil)
    }
    
    func backFromSharing() {
        print("Back from sharing")
        bottomShareButton.isHidden = false
    }
    
    // Document controller is class level variable needed for instagram sharing code below
    var docController: UIDocumentInteractionController?
    
    // Class level variables that will be used to pass images to the view controller
    // asset is for images passed from camera roll
    var asset: PHAsset?
    // image is for single images passed directly from camera
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Sets myAsset as the photo from camera roll tapped, if any
        if let myAsset = asset {
            PHImageManager.default().requestImage(
                for: myAsset,
                targetSize: CGSize(
                    width: self.view.frame.height,
                    height: self.view.frame.width),
                contentMode: .aspectFit,
                options: nil,
                resultHandler: { (result, info) in
                    if let image = result {
                        self.imageView.image = image
                    }
            })
        // If coming from camera, sets imageView to the photo taken and passed from camera
        } else if (image != nil) {
            self.imageView.image = image
        // Otherwise no images are available to display, and returns to list view
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
               
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    // Called anytime we are about to navigate away from current view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            if (id == "shareImageSegue") {
                let vc = segue.destination as! ShareImageViewController
                vc.myImage = imageView.image
                
                // in conjunction with protocol CommunicationControllerSharing
                vc.delegate = self
            }
        }
    }
}
