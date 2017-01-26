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


class ShowImageViewController: UIViewController, UIDocumentInteractionControllerDelegate {

    // MARK: - Variables and Outlets
    
    // asset is for images passed from camera roll
    var asset: PHAsset?
    // image is for single images passed directly from camera
    var image: UIImage?
    // Document controller is class level variable needed for instagram sharing code below
    var docController: UIDocumentInteractionController?
    
    // View of the full sized image we are sharing
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var bottomShareButton: UIButton!
    @IBAction func tapBottomShareButton(_ sender: UIButton) {
        // hide sharing button that's covered by modal ShareImageVC
        sender.isHidden = true
        
        performSegue(withIdentifier: "shareImageSegue", sender: nil)
    }
    
    // Navigate back to camera roll view since ShowImageVC is presented modally
    @IBAction func tapBackArrowButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        // unhides sharing button that's hidden when sharing menu is opened
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            if (id == "shareImageSegue") {
                let vc = segue.destination as! ShareImageViewController
                vc.myImage = imageView.image
            }
        }
    }
}
