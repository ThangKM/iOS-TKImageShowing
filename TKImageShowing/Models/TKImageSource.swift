//
//  TKImageSource.swift
//  TKImageShowing
//
//  Created by ThangKieu on 5/26/18.
//  Copyright © 2018 ThangKieu. All rights reserved.
//

import UIKit
import SDWebImage

open class TKImageSource {
    open var url:String?
    open var image:UIImage?
    
    public init(url:String?, image:UIImage?) {
        self.url = url
        self.image = image
    }
}

extension Array where  Element == String  {
    public func toTKImageSource() -> [TKImageSource] {
        var arr = [TKImageSource]()
        self.forEach { (urlString) in
            arr.append(TKImageSource(url: urlString, image: nil))
        }
        return arr
    }
}

extension Array where  Element:UIImage {
    public func toTKImageSource() -> [TKImageSource] {
        var arr = [TKImageSource]()
        self.forEach { (image) in
            arr.append(TKImageSource(url: nil, image: image))
        }
        return arr
    }
}
