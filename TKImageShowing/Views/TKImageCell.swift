//
//  TKImageCell.swift
//  TKImageShowing
//
//  Created by ThangKieu on 5/8/18.
//  Copyright © 2018 ThangKieu. All rights reserved.
//

import UIKit

 open class TKImageCell: UICollectionViewCell {
    
    open var imageItem:TKImageItem!
    private var originalImagePos:CGPoint?
    private var isInit = true
    var endZoom:VoidCallBack?{
        didSet{
            self.imageItem.endZoom = self.endZoom
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK:- Common init
    func commonInit() {
        imageItem = TKImageItem()
        self.addSubview(imageItem)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.quickZoom))
        self.isUserInteractionEnabled = true
        tapGesture.numberOfTapsRequired = 2
        self.addGestureRecognizer(tapGesture)
    }
    
    func config(with zoomable:Zoomable) {
        imageItem.maximumZoom = zoomable.maximumZoom
        imageItem.canZoom = zoomable.canZoom
        imageItem.spacing = zoomable.spacing
        imageItem.bgColor = zoomable.bgColor
        imageItem.update()
    }
    
    @objc func quickZoom() {
        if self.imageItem.zoomScale == 1 {
            self.imageItem.setZoomScale(self.imageItem.maximumZoom, animated: true)
        } else {
            self.imageItem.setZoomScale(1, animated: true)
        }
        
    }
    
    func setImage(_ image:TKImageSource) {
        self.imageItem.setImage(image)
    }
    
    @objc func resetZoom(isDismiss:Bool = false) {
        imageItem.resetZoom(isDismiss: isDismiss)
    }
    
}




