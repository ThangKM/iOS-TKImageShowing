//
//  File.swift
//  Pods
//
//  Created by ThangKieu on 5/30/18.
//

import UIKit

public protocol Zoomable:class {
    // maximum of value zoom scale
    var maximumZoom:CGFloat { get set }
    
    // enable or disable zoom
    var canZoom:Bool { get set }
    
    // spacing between items
    var spacing:CGFloat { get set }
    
    // background color of scroll view cover image
    var bgColor:UIColor { get set }
}
