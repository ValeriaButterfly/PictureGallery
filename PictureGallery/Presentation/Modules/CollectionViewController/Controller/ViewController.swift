//
//  ViewController.swift
//  PictureGallery
//
//  Created by Valeria Muldt on 23.10.2020.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.hidesWhenStopped = true
        }
    }
    
    var picturesArray = [GetPhotoResponse]()
    var savedPicturesArray: [Picture] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        activityIndicator.startAnimating()
        
        GetPhoto.getArray { [self] (response) in
            guard let dataArray = response else {
                self.alert()
                return }
            
            
            self.picturesArray = dataArray
            
            self.activityIndicator.stopAnimating()
            
            CoreDataHelper.getImage(array: &savedPicturesArray)
            
            self.collectionView.reloadData()
            self.layoutCells()
//            print(self.picturesArray)
            print("SAVED PICTURES = \(savedPicturesArray)")
        }
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picturesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MainCollectionViewCell
        
        cell.titleLabel.text = picturesArray[indexPath.row].title
        
        if savedPicturesArray.contains(where: { $0.id == picturesArray[indexPath.row].id }) {
            cell.statusLabel.text = "local"
        } else {
            cell.statusLabel.text = "on web"
        }
        
        cell.statusLabel.textColor = cell.statusLabel.text == "on web" ? .red : .green
        
        GetPhoto.getImage(url: picturesArray[indexPath.row].thumbnailUrl) { (error, data)  in
            if error != nil {
                self.alert()
                return
            }
            
            guard let dataImage = data else { return }
            
            DispatchQueue.main.async {
                guard let image = UIImage(data: dataImage) else {  return }
                cell.thumbnailImageView.image = image
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let originalPictureVC = storyboard.instantiateViewController(identifier: "OriginalPictureViewController") as? OriginalPictureViewController else { return }
        
        if savedPicturesArray.contains(where: { $0.id == picturesArray[indexPath.row].id }) {
            
            guard let index = savedPicturesArray.firstIndex(where: { $0.id == picturesArray[indexPath.row].id }) else { return }
            originalPictureVC.originalPhoto = savedPicturesArray[index].image
            
        } else {
            originalPictureVC.originalPhotoURL = picturesArray[indexPath.row].url
            originalPictureVC.originalPhotoID = picturesArray[indexPath.row].id
        }
        
        originalPictureVC.delegate = { [self] text in
            print(text)
            CoreDataHelper.getImage(array: &self.savedPicturesArray)
            self.collectionView.reloadItems(at: [indexPath])
        }
        
        present(originalPictureVC, animated: true, completion: nil)
        
    }
}


// MARK: - CollectionViewCellLayout
private extension ViewController {
    func layoutCells() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 5.0
        layout.minimumLineSpacing = 5.0
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.size.width - 40)/2, height: ((UIScreen.main.bounds.size.width - 40)/2))
        collectionView!.collectionViewLayout = layout
    }
}
