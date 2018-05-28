//
//  MoveOutAnimatedTransitioning.swift
//  TKImageShowing
//
//  Created by ThangKieu on 5/26/18.
//  Copyright © 2018 ThangKieu. All rights reserved.
//

import UIKit

@objcMembers
class MoveOutPresentAnimatedTransitioning: NSObject,
UIViewControllerAnimatedTransitioning{
    
    weak var referenceView:UIImageView? // of toVC
    weak var referenceCell:TKImageCell? // of fromVC
    
    init(animatedView:UIImageView?,animatedCell:TKImageCell?){
        self.referenceView = animatedView
        self.referenceCell = animatedCell
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let fromVC = transitionContext.viewController(forKey: .from)!
        let toVC = transitionContext.viewController(forKey: .to)!
        
        let containerView = transitionContext.containerView
        let animatedView = referenceCell?.imageItem.imageView.snapshotView(afterScreenUpdates: true)

        weak var imvOfToVC:UIImageView! // UIImageView of fromView
        
        if let tkView = referenceView as? TKImageView{
            tkView.isSelectedToShowFullScreen = false
            imvOfToVC = referenceView
            imvOfToVC.isHidden = true
        }else if referenceView != nil{
            imvOfToVC = referenceView
            imvOfToVC.isHidden = true
        }
        
        containerView.addSubview(toVC.view)
        
        guard let snapShot = toVC.view.snapshotView(afterScreenUpdates: true) else{
            transitionContext.completeTransition(true)
            return
            
        } //snapshot fromview when animated view was hidden
        if let vwAnimated = animatedView, imvOfToVC != nil{
            
            let bgView = UIView(frame: toVC.view.bounds)
            bgView.backgroundColor = UIColor.black
            bgView.alpha = 1
            
            containerView.addSubview(snapShot)
            containerView.addSubview(bgView)
            containerView.addSubview(vwAnimated)
            toVC.view.isHidden = true
            vwAnimated.contentMode = imvOfToVC.contentMode
            let originFrame = imvOfToVC.frame
            vwAnimated.center = fromVC.view.center
            if let superView = imvOfToVC.superview{
                 imvOfToVC.frame = superView.convert(imvOfToVC.frame, to: nil)
            }
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, options: .curveEaseInOut, animations: {
                if imvOfToVC.superview != toVC.view{
                    vwAnimated.frame = imvOfToVC.frame
                }else{
                     vwAnimated.frame = originFrame
                }
                bgView.alpha = 0
                
            }, completion: {
                finished in
                bgView.removeFromSuperview()
                vwAnimated.removeFromSuperview()
                snapShot.removeFromSuperview()
                toVC.view.isHidden = false
                imvOfToVC.isHidden = false
                imvOfToVC.frame = originFrame
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }else{
            toVC.view.isHidden = false
            imvOfToVC.isHidden = false
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

