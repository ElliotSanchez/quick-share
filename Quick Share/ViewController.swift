//
//  ViewController.swift
//  Quick Share
//
//  Created by hostname on 10/31/16.
//  Copyright © 2016 notungood. 
//  All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    // MARK: - Variables and Outlets
    // Variables to store the photos
    var assetCollection: PHAssetCollection?
    var photos: PHFetchResult<PHAsset>?
    var image = UIImage()
    
    // Variable to store the photo access status for checking
    let photoAccessStatus = PHPhotoLibrary.authorizationStatus()
    
    // Variable to choose photos from camera roll
    var imagePicker = UIImagePickerController()
    
    // Table of photo thumbnails / previews
    let reuseIdentifier = "tableViewCell"
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    
    @IBAction func tapCircleCameraButton(_ sender: UIButton) {
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the data source and delegated responder for our tableView as this viewController class, aka, self
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - Photo Library and Camera Handling
    override func viewWillAppear(_ animated: Bool) {
        
        // If photo library access has already been granted
        if let collection = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil).firstObject {
            // background thread to load the asset collection
            DispatchQueue.main.async() {
                self.assetCollection = collection
                    
                let options = PHFetchOptions()
                options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
                options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                
                self.photos = PHAsset.fetchAssets(in: self.assetCollection!, options: options)
                self.tableView.reloadData()
                
                self.activitySpinner.stopAnimating()
            }
        } else {
            checkPhotoLibraryPermission()
        }
    }
    
    // Adapted from http://stackoverflow.com/questions/26595343/determine-if-the-access-to-photo-library-is-set-or-not-ios-8#26595480
    func checkPhotoLibraryPermission() {
        switch photoAccessStatus {
        case .authorized:
            print("Access previously authorized.")
            tableView.reloadData()
        case .denied, .restricted :
            print("Photo access previously denied by the user.")
        case .notDetermined:
            print("Prompting for photo library access...")
            // ask for permissions
            PHPhotoLibrary.requestAuthorization() { photoAccessStatus in
                switch photoAccessStatus {
                case .authorized:
                    print("Access authorized in user prompt, calling viewWillAppear.")
                    self.viewWillAppear(true)
                case .denied, .restricted:
                    print("Photo access denied by the user in prompt.")
                case .notDetermined:
                    print("Unclear how photo access was resolved by user in prompt.")
                }
                print("Completed checkPhotoLibraryPermission authorization request.")
            }
        }
    }
    
    // called on completion of camera view
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        
        // set class level image variable to image taken, used in prepareForSeque as well
        if let newImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
             image = newImage
        }
        
        UIImageWriteToSavedPhotosAlbum(self.image, self, nil, nil)
        
        performSegue(withIdentifier: "showFullImageSegue", sender: self)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            if (id == "showFullImageSegue") {
                let newVc = segue.destination as! ShowImageViewController
               
                // differentiate between sender as table vs camera
                if sender is UITableViewCell {
                    // define indexPath since it isn't passed explicitly to prepare(for segue)
                    var indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
                    
                    if let asset = self.photos?[(indexPath?.row)!] {
                        newVc.asset = asset
                    }
                } else {
                    newVc.image = image
                }
            }
        }
    }
    
    // MARK: - UITableViewDataSource Required Functions
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
    
    // Currently sets length of table to match number of photos 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let numberOfPhotos = self.photos?.count {
            return numberOfPhotos
        } else {
            return 1
        }
    }
    
    // MARK: - UITableViewDelegate Required Function
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

