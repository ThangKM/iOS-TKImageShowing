//
//  MoveOutAnimatedTransitioning.swift
//  TKImageShowing
//
//  Created by ThangKieu on 5/26/18.
//  Copyright © 2018 ThangKieu. All rights reserved.
//

import UIKit
import AVFoundation

@objcMembers
class MoveOutPresentAnimatedTransitioning: NSObject,
UIViewControllerAnimatedTransitioning{
    
    weak var referenceView:UIImageView? // of toVC
    weak var referenceCell:TKImageCell? // of fromVC
    
    private var isAnimated:Bool
    
    init(animatedView:UIImageView?,animatedCell:TKImageCell?,isAnimated:Bool = true) {
        self.referenceView = animatedView
        self.referenceCell = animatedCell
        self.isAnimated = isAnimated
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let fromVC = transitionContext.viewController(forKey: .from)!
        let toVC = transitionContext.viewController(forKey: .to)!
        
        let containerView = transitionContext.containerView
        let animatedView = referenceCell?.imageItem.imageView.snapshotView(afterScreenUpdates: true)
        
        if let tkView = referenceView as? TKImageView{
            tkView.isSelectedToShowFullScreen = false
        }
        if referenceView?.image != nil && isAnimated{
            referenceView?.isHidden = true
        }
        containerView.addSubview(toVC.view)
        
        guard let snapShot = toVC.view.snapshotView(afterScreenUpdates: true) else {
            transitionContext.completeTransition(true)
            return
            
        } //snapshot fromview when animated view was hidden
        if let vwAnimated = animatedView, let referenceView = self.referenceView {

            let bgView = UIView(frame: toVC.view.bounds)
            bgView.backgroundColor = UIColor.black
            bgView.alpha = 1
            containerView.addSubview(snapShot)
            containerView.addSubview(bgView)
            containerView.addSubview(vwAnimated)
            toVC.view.isHidden = true
            vwAnimated.contentMode = referenceView.contentMode
            let originFrame = referenceView.frame
            vwAnimated.center = fromVC.view.center
            if let superView = referenceView.superview{
                 referenceView.frame = superView.convert(referenceView.frame, to: nil)
            }
            
            var imageSize:CGSize = referenceView.bounds.size
            if let image = referenceView.image{
                if referenceView.contentMode == .scaleAspectFit{
                    imageSize = AVMakeRect(aspectRatio: image.size, insideRect: referenceView.bounds).size
                }
            }
            
            let spacingTop = (referenceView.bounds.size.height - imageSize.height)/2
            let spacingLeft = (referenceView.bounds.size.width - imageSize.width)/2
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, options: .curveEaseInOut, animations: {
                if self.isAnimated{
                    if referenceView.superview != toVC.view{
                        vwAnimated.frame = CGRect(x: referenceView.frame.origin.x + spacingLeft,
                                                  y: referenceView.frame.origin.y + spacingTop,
                                                  width: imageSize.width,
                                                  height: imageSize.height)
                    }else{
                        vwAnimated.frame = originFrame
                    }
                }else{
                    vwAnimated.alpha = 0
                    vwAnimated.frame = .zero
                }
                bgView.alpha = 0
                
            }, completion: {
                finished in
                bgView.removeFromSuperview()
                vwAnimated.removeFromSuperview()
                snapShot.removeFromSuperview()
                toVC.view.isHidden = false
                referenceView.isHidden = false
                referenceView.frame = originFrame
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        } else {
            toVC.view.isHidden = false
            referenceView?.isHidden = false
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

