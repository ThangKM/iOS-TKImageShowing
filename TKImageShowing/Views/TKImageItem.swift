//
//  TKImageItem.swift
//  TKImageShowing
//
//  Created by ThangKieu on 5/25/18.
//  Copyright © 2018 ThangKieu. All rights reserved.
//

import UIKit
typealias VoidCallBack = ()->()

open class TKImageItem: UIScrollView{
    
    //MARK: - SUPPORT VARIABLE
    open var maximumZoom = CGFloat(3)
    open var zoomEnable = true
    open var spacing = CGFloat(10)
    var endZoom:VoidCallBack?
    open let imageView = UIImageView(frame: UIScreen.main.bounds)
 
    //MARK: - LYFE CYCLE
    public init() {
        super.init(frame: UIScreen.main.bounds)
        setupUI()
        self.addSubview(imageView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     //MARK: - CONFIG
    func setupImage(){
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.frame.size = self.calculateImageViewFrame()
        setPictoCenter()
    }
    
    private func setupUI(){
        
        maximumZoomScale = self.maximumZoom
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        delegate = self
    }

    open func update(){
        setupUI()
        setupImage()
    }
    
    //MARK: - SUPPORT FUNCTION
    
    open func setImage(_ source:TKImageSource){
        if let img = source.image{
            imageView.image = img
            setupImage()
        }else{
            if let urlString = source.url{
                if let url = URL(string: urlString){
                    self.imageView.sd_setIndicatorStyle(.white)
                    self.imageView.sd_setShowActivityIndicatorView(true)
                    self.imageView.sd_addActivityIndicator()
                    self.imageView.sd_setImage(with: url) { (image, _, _, _) in
                        DispatchQueue.main.async {
                            self.imageView.image = image
                            self.setupImage()
                        }
                    }
                }
            }
        }
    }
    
    func calculateImageViewFrame() -> CGSize{
        
        if let image = imageView.image, imageView.contentMode == .scaleAspectFit{
            let picSize = image.size
            let picRatio = picSize.width / picSize.height
            let screenRatio = screenSize().width / screenSize().height
            
            if picRatio > screenRatio{
               
                return CGSize(width: screenSize().width - spacing,
                              height: screenSize().width  / picSize.width * (picSize.height - spacing))
            }else{
                return CGSize(width: screenSize().height / picSize.height  * picSize.width, height: screenSize().height)
            }
        }else{
            return CGSize(width: screenSize().width, height: screenSize().height)
        }
    }
    
    func setPictoCenter() {
        var intendHorizon = (screenSize().width - imageView.frame.width ) / 2
        var intendVertical = (screenSize().height - imageView.frame.height ) / 2
        intendHorizon = max(0, intendHorizon)
        intendVertical = max(0, intendVertical)
        contentInset = UIEdgeInsets(top: intendVertical, left: intendHorizon, bottom: intendVertical, right: intendHorizon)
        contentSize.height = imageView.frame.height
    }
    
    func screenSize()->CGSize{
        return frame.size
    }
    
    open func resetZoom(isDismiss:Bool = false){
        if zoomScale != 1{
            setZoomScale(1, animated: true)
        }else{
            if isDismiss{
                self.endZoom?()
            }
        }
    }
}

//MARK:- EXTENSION

extension TKImageItem: UIScrollViewDelegate{
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.setPictoCenter()
    }
    
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        self.endZoom?()
    }
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return zoomEnable ? self.imageView : nil
    }
    
}



