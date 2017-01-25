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

// modified from example at 
// http://stackoverflow.com/questions/25759945/pass-data-when-dismiss-modal-viewcontroller-in-swift
// used to tell the share button on the ShowImageVC to return alpha to normal
protocol CommunicationControllerSharing {
    func backFromSharing()
}

class ShareImageViewController: UIViewController, UIDocumentInteractionControllerDelegate {
    
    // used to tell the share button on the ShowImageVC to return alpha to normal
    var delegate: CommunicationControllerSharing? = nil
    
    
    @IBAction func tapBigInvisibleButton(_ sender: Any) {
        self.dismiss(animated: true) {
        
            // show share button again when sharing options view is hidden
            print("tapped BigInvisible Button")
            
        }
    }
    
    // Document controller is class level variable needed for instagram sharing code below
    var docController: UIDocumentInteractionController?
    
    // image is for single images passed from Preview viewController
    var myImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate?.backFromSharing()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    
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
