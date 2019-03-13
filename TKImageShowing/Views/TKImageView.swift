//
//  TKImageView.swift
//  TKImageShowing
//
//  Created by ThangKieu on 5/8/18.
//  Copyright © 2018 ThangKieu. All rights reserved.
//

import UIKit

open class TKImageView: UIImageView {
    
    @IBInspectable var zoomalbe:Bool =  true
    
    @IBInspectable var spacing:CGFloat =  CGFloat(10)
    
    @IBInspectable var maximumZoom:CGFloat =  CGFloat(3)
    
    @IBInspectable var bgColor:UIColor =  .black
    
    var isSelectedToShowFullScreen = false
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        commonInit()
    }
    
    private func commonInit(){
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.presentFullScreen)))
    }
    
    @objc private func presentFullScreen() {
        isSelectedToShowFullScreen = true
        let vc = TKImageShowing()
        vc.canZoom = self.zoomalbe
        vc.spacing = spacing
        vc.maximumZoom = maximumZoom
        vc.bgColor = self.bgColor
        vc.animatedView = self
        vc.images = [TKImageSource(url:nil,image: self.image)]
        self.parentViewController?.present(vc, animated: true, completion: nil)
    }
}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

