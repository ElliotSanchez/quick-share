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

    @IBOutlet weak var imageView: UIImageView!
    
    var asset: PHAsset?
    
    @IBAction func shareButtonClicked (_ sender: UIButton) {
        switch sender.tag {
        case 1:
            if let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook) {
                shareFacebookTwitter(vc: vc)
            }
        case 2: print("instagram")
        case 3: print("fb messenger")
        case 4:
            if let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter) {
                shareFacebookTwitter(vc: vc)
            }
        case 5: print("pinterest")
        case 6: print("whatsapp")
        default: print("nothing")
        }
    }
    
    func shareFacebookTwitter (vc: SLComposeViewController) {
        vc.setInitialText("Check out this picture I shared with Quick Share!")
        vc.add(imageView.image)
        present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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
