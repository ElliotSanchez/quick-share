//
//  ViewController.swift
//  Quick Share
//
//  Created by hostname on 10/31/16.
//  Copyright © 2016 notungood. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // Class level variables to store the photos
    var assetCollection: PHAssetCollection?
    var photos: PHFetchResult<PHAsset>?
    
    @IBOutlet weak var tableView: UITableView!
    
    let reuseIdentifier = "tableViewCell"
    
    // dummy array to check and make sure table view is working. 
    // var dummyObjects = ["hi", "hello", "there", "I'm", "awesome!"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set the data source and delegated responder for our tableView as this viewController class, aka, self
        tableView.dataSource = self
        tableView.delegate = self
        
        // Get the photos and put them in the class level variables created earlier
        let collection = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        
        if (collection.firstObject != nil) {
            self.assetCollection = collection.firstObject!
            
            let options = PHFetchOptions()
            options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            
            self.photos = PHAsset.fetchAssets(in: assetCollection!, options: options)
        } else {
            print("No photos found during viewDidLoad")
        }
    }

    // Called anytime we are about to navigate away from current view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            if (id == "showFullImageSegue") {
                let newVc = segue.destination as! ShowImageViewController
                newVc.passedString = "we passed the data"
            }
        }
    }
    
    //////////////////////////////////////////////
    // UITableViewDataSource REQUIRED FUNCTIONS //
    //////////////////////////////////////////////
    // Returns cell for display using custom MyTableViewCell class
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyTableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MyTableViewCell
        
        if let asset = self.photos?[indexPath.row] {
            PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 320, height: 240), contentMode: .aspectFill, options: nil, resultHandler: { (result, info) in
                if result != nil {
                    cell.myImageView?.image = result
                }
            })
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Currently sets length of table at fixed length
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    ///////////////////////////////////
    // UITableViewDelegate FUNCTIONS //
    ///////////////////////////////////
    //
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

