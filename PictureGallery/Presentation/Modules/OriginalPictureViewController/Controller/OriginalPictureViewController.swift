//
//  OriginalPictureViewController.swift
//  PictureGallery
//
//  Created by Valeria Muldt on 26.10.2020.
//

import UIKit

class OriginalPictureViewController: UIViewController {
    @IBOutlet weak var originalImageView: UIImageView!
    
    var originalPhotoURL: String?
    var originalPhotoID: Int?
    var originalPhoto: Data?
    
    var delegate: ((String)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = originalPhotoURL,
           let id = originalPhotoID {
            GetPhoto.getImage(url: url) { (error, data) in
                if error != nil {
                    self.alert()
                    return
                }
                
                guard let imageData = data,
                      let image = UIImage(data: imageData)
                      else { return }
                
                print("GET FROM WEB")
                
                DispatchQueue.main.async {
                    self.originalImageView.image = image
                }
                
                CoreDataHelper.saveImage(id: id, image: image)
            }
        } else {
            // GET ORIGINAL PHOTO FROM CORE DATA
            print("GET FROM CORE DATA")
            
            guard let imageData = originalPhoto,
                  let image = UIImage(data: imageData) else { return }
            
            DispatchQueue.main.async {
                self.originalImageView.image = image
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        print("View DID Disappear")
        
        if originalPhotoURL != nil {
            delegate?("Delegate works")
        }
    }
}
