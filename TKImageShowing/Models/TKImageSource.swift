//
//  TKImageSource.swift
//  TKImageShowing
//
//  Created by ThangKieu on 5/26/18.
//  Copyright © 2018 ThangKieu. All rights reserved.
//

import UIKit
import SDWebImage

open class TKImageSource{
    open var url:String?
    open var image:UIImage?
    
    public init(url:String?, image:UIImage?) {
        self.url = url
        self.image = image
    }
}
