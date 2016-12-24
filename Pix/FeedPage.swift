//
//  FeedPage.swift
//  Pix
//
//  Created by Adeola Uthman on 12/23/16.
//  Copyright © 2016 Adeola Uthman. All rights reserved.
//

import UIKit

class FeedPage: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    /********************************
     *
     *          VARIABLES
     *
     ********************************/
    
    /* Image picker */
    let imgPicker = UIImagePickerController();
    
    
    
    
    
    
    
    /********************************
     *
     *          METHODS
     *
     ********************************/

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 239/255, green: 255/255, blue:245/255, alpha: 1);
        navigationController?.navigationBar.isHidden = false;
        navigationItem.hidesBackButton = true;
        collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell");

        
        // Image Picker.
        imgPicker.delegate = self;
        imgPicker.sourceType = .photoLibrary;
        
        
        // Add a button for uploading photos.
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(uploadPhoto));
        addButton.tintColor = UIColor.white;
        navigationItem.rightBarButtonItem = addButton;
        
    } // End of viewDidLoad().

    
    
    
    
    
    
    
    
    /********************************
     *
     *       IMAGE PICKER
     *
     ********************************/
    
    @objc func uploadPhoto() {
        show(imgPicker, sender: self);
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let photo = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            let vc = UploadPhotosViewController();
            let post = Post(photo: photo, caption: "", Uploader: currentUser);
            vc.post = post;
            vc.imageView.image = photo;
            navigationController?.pushViewController(vc, animated: true);
            imgPicker.dismiss(animated: true, completion: nil);
            
        }
    }
    
    
    
    
    
    
    
    
    
    /********************************
     *
     *       COLLECTION VIEW
     *
     ********************************/

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1;
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath);
    
        // Configure the cell
    
        return cell
    }


}
