# TKImageShowing

- Tap on an image to show it full screen

![](https://github.com/ThangKM/iOS-TKImageShowing/blob/master/Images/giphy%202.gif)



## Requirements

- iOS 10 or later
- Xcode 8 or later

## 📱 Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

### Installing with CocoaPods

#### Podfile
```
platform :ios, '9.0'
pod 'TKImageShowing'
```
## 🔨 How to use
#### Storyboard

![](https://github.com/ThangKM/iOS-TKImageShowing/blob/master/Images/Screen%20Shot%202018-06-02%20at%201.22.13%20PM.png)

#### Show list images in a UICollectionView 

```swift
import UIKit
import TKImageShowing

let tkImageVC = TKImageShowing()
let arrImages = [
        "https://www.gstatic.com/webp/gallery3/2.png",
        "https://www.gstatic.com/webp/gallery3/3_webp_ll.png",
        "https://www.gstatic.com/webp/gallery/2.jpg"
    ]

 override func viewDidLoad() {
        super.viewDidLoad()
        tkImageVC.images = arrImages.toTKImageSource()
 }
 
 func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let cell = collectionView.cellForItem(at: indexPath) as! ImageCell
        self.tkImageVC.animatedView  = cell.imageView
        self.tkImageVC.currentIndex = indexPath.row
        self.present(self.tkImageVC, animated: true, completion: nil)
  }
	
```

## Authors

[Thang Kieu](https://github.com/ThangKM)

## License

All source code is licensed under the [MIT License](https://github.com/ThangKM/iOS-TKImageShowing/blob/master/LICENSE).

