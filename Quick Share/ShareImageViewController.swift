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

class ShareImageViewController: UIViewController, UIDocumentInteractionControllerDelegate {
    
    // MARK: - Variables and Outlets
    
    // Document controller is class level variable needed for instagram sharing code below
    var docController: UIDocumentInteractionController?
    
    // image is for single images passed from Preview viewController
    var myImage: UIImage?
    
    // kludgy workaround to dismiss view when user taps in empty space on screen
    // clear button that autosizes to screen that isn't covered by sharing service stack of buttons
    @IBAction func tapBigInvisibleButton(_ sender: Any) {
        print("tapBigInvisibleButton")
        self.dismiss(animated: true)
    }
    
    // kludgy workaround to return to camera roll view when user attempts to tap back arrow
    // clear button that takes up top 120x120 pixels, same size as back arrow plus padding
    // this elegant solution without delegates or protocols adapted from 
    // http://stackoverflow.com/questions/14907518/modal-view-controllers-how-to-display-and-dismiss/29671682#29671682
    @IBAction func tapSmallInvisibleButton(_ sender: Any) {
        print("tapSmallInvisibleButton")
        let camRollVC = storyboard?.instantiateViewController(withIdentifier: "CameraRollVC") as! ViewController
        let showImageVC = self.presentingViewController
        self.dismiss(animated: false, completion: { () -> Void   in
            showImageVC!.present(camRollVC, animated: true, completion: nil)
        })
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
        case 3: print("placeholder for fb messenger")
        case 4:
            if let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter) {
                shareFacebookTwitter(vc: vc)
            }
        case 5: print("placeholder for pinterest")
        case 6:
            shareWhatsapp()
        default: print("nothing")
        }
    }
    
    
    // MARK: - Sharing Service Functions 
    
    // Facebook and Twitter
    func shareFacebookTwitter (vc: SLComposeViewController) {
        vc.setInitialText("Check out this picture I shared with Quick Share")
        vc.add(myImage)
        present(vc, animated: true, completion: nil)
    }
    
    // Instagram
    func shareInstagram () {
        let InstagramURL = URL(string: "instagram://app")
        if (UIApplication.shared.canOpenURL(InstagramURL!)) {
            let imageData = UIImageJPEGRepresentation(myImage!, 75)
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
            let imageData = UIImageJPEGRepresentation(myImage!, 75), //and
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
}
