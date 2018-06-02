//
//  ViewController.swift
//  TKImageShowing
//
//  Created by ThangKieu on 5/3/18.
//  Copyright © 2018 ThangKieu. All rights reserved.
//

import UIKit
import TKImageShowing

class ViewController:UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    let arrImages = [
        "https://www.gstatic.com/webp/gallery3/2.png",
        "https://www.gstatic.com/webp/gallery3/3_webp_ll.png",
        "https://www.gstatic.com/webp/gallery/2.jpg"
    ]
    
    let tkImageVC = TKImageShowing()
    
    @IBOutlet weak var cvwImages: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var imageSource = [TKImageSource]()
        arrImages.forEach { (urlString) in
            imageSource.append(TKImageSource(url: urlString, image: nil))
        }
        tkImageVC.images = imageSource
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cvwImages.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        cell.imageView.sd_setImage(with: URL(string: arrImages[indexPath.row]))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let cell = collectionView.cellForItem(at: indexPath) as! ImageCell
        self.tkImageVC.animatedView  = cell.imageView
        self.tkImageVC.currentIndex = indexPath.row
        self.present(self.tkImageVC, animated: true, completion: nil)
    }
}

