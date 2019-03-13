//
//  FlipPresentAnimatedTransitioning.swift
//  TKImageShowing
//
//  Created by ThangKieu on 5/26/18.
//  Copyright © 2018 ThangKieu. All rights reserved.
//

import UIKit

@objcMembers
class MoveInPresentAnimatedTransitioning: NSObject,
UIViewControllerAnimatedTransitioning {
    
    weak var referenceView:UIImageView? // of fromVC

    init(animatedView:UIImageView?){
        self.referenceView = animatedView
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
        
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: .from)!
        let toVC = transitionContext.viewController(forKey: .to)!
        
        let containerView = transitionContext.containerView
        
        let animatedView:UIView? = referenceView?.snapshotView(afterScreenUpdates: true)
        containerView.addSubview(toVC.view)
        
        referenceView?.isHidden = true
        guard let snapShot = fromVC.view.snapshotView(afterScreenUpdates: true) else{
            transitionContext.completeTransition(true)
            return
            
        } //snapshot fromview when animated view was hidden
        if let vwAnimated = animatedView, let tkimageView  = self.referenceView, tkimageView.image != nil {
            vwAnimated.contentMode = tkimageView.contentMode
            let bgView = UIView(frame: toVC.view.bounds)
            bgView.backgroundColor = UIColor.black
            bgView.alpha = 0
            
            toVC.view.isHidden = true
            containerView.addSubview(snapShot)
            containerView.addSubview(bgView)
            containerView.addSubview(vwAnimated)
            
            let originFrame = tkimageView.frame
            
            if let superView = tkimageView.superview {
                 tkimageView.frame = superView.convert(tkimageView.frame, to: nil)
            }
             vwAnimated.frame = tkimageView.frame
            
            var imvViewToVC:UIView?
            if let tkVC = toVC as? TKImageShowing{
                if let  cell = tkVC.currentCell{
                    if let imvSnapshot = cell.imageItem.imageView.snapshotView(afterScreenUpdates: true) {
                        imvViewToVC = imvSnapshot
                        imvViewToVC?.center = toVC.view.center
                    }
                }
            }
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, options: .curveLinear, animations: {
                
                if let imageView = imvViewToVC{
                    vwAnimated.frame = imageView.frame
                }else{
                    vwAnimated.center = toVC.view.center
                }
                bgView.alpha = 1
                
            }, completion: {
                finished in
                
                bgView.removeFromSuperview()
                vwAnimated.removeFromSuperview()
                snapShot.removeFromSuperview()
                toVC.view.isHidden = false
                tkimageView.frame = originFrame
                tkimageView.isHidden = false
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        } else {
            referenceView?.isHidden = false
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

