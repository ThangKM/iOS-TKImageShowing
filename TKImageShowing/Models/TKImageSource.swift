//
//  TKImageSource.swift
//  TKImageShowing
//
//  Created by ThangKieu on 5/26/18.
//  Copyright © 2018 ThangKieu. All rights reserved.
//

import UIKit
import SDWebImage

class TKImageSource{
    var url:String?
    var image:UIImage?
    
    init(url:String?, image:UIImage?) {
        self.url = url
        self.image = image
    }
}
