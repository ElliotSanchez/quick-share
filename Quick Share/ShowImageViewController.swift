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

    // View of the full sized image we are sharing
    @IBOutlet weak var imageView: UIImageView!
    
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
                    width: self.view.frame.width,
                    height: self.view.frame.width),
                contentMode: .aspectFill,
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

  
    
    
    // Single outlet for all sharing buttons, differentiated by tags, numbered 1-6
    // Each calls a sharing function below
    @IBAction func shareButtonClicked (_ sender: UIButton) {
        switch sender.tag {
        case 1:
            if let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook) {
                shareFacebookTwitter(vc: vc)
            }
        case 2:
            shareInstagram()
        case 3: print("fb messenger")
        case 4:
            if let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter) {
                shareFacebookTwitter(vc: vc)
            }
        case 5: print("pinterest")
        case 6:
            shareWhatsapp()
        default: print("nothing")
        }
    }
    
   
    ////////////////////////////////////////
    // SERVICE SPECIFIC SHARING FUNCTIONS //
    ////////////////////////////////////////
    // Facebook and Twitter
    func shareFacebookTwitter (vc: SLComposeViewController) {
        vc.setInitialText("Check out this picture I shared with Quick Share")
        vc.add(imageView.image)
        present(vc, animated: true, completion: nil)
    }
    
    // Instagram
    func shareInstagram () {
        let InstagramURL = URL(string: "instagram://app")
        if (UIApplication.shared.canOpenURL(InstagramURL!)) {
            let imageData = UIImageJPEGRepresentation(imageView.image!, 75)
            let captionString = "Check out this picture I shared with Quick Share"
            
            let writePath = (NSTemporaryDirectory() as NSString).appending("instagram.igo")
            
            do {
                try imageData?.write(to: URL(fileURLWithPath: writePath), options: [.atomicWrite])
                let fileURL = URL(fileURLWithPath: writePath)
                
                self.docController = UIDocumentInteractionController(url: fileURL)
                self.docController?.delegate = self
                self.docController?.uti = "com.instagram.exclusivegram"
                self.docController?.annotation = NSDictionary(object: captionString, forKey: "InstagramCaption" as NSCopying)
                self.docController?.presentOpenInMenu(from: self.view.frame, in: self.view, animated: true)
            } catch {
                print("Error sharing to instagram in ShowImageViewController.ShareInstagram()")
            }
            
        }
    }

    // Whatsapp
    func shareWhatsapp () {
        let whatsappURL = URL(string: "whatsapp://app")
        
        // Bound conditionals
        if UIApplication.shared.canOpenURL(whatsappURL!), //and
        let image = imageView.image, //and
        let imageData = UIImageJPEGRepresentation(image, 75), //and
        let tempFile = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Documents/whatsAppTmp.wai") as URL? { //then
            do {
                try imageData.write(to: tempFile, options: .atomicWrite)
                self.docController = UIDocumentInteractionController(url: tempFile)
                self.docController?.uti = "net.whatsapp.image"
                self.docController?.presentOpenInMenu(from: self.view.frame, in:self.view, animated: true)
            } catch {
                print("Error in ShowImageViewController.shareWhatsapp()")
            }
        } else {
            print("Error finding your image or the Whatsapp application")
        }
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
