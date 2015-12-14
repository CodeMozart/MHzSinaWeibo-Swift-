//
//  PopoverAnimationManager.swift
//  SinaWeibo
//
//  Created by Minghe on 11/10/15.
//  Copyright © 2015 Stanford swift. All rights reserved.
//

import UIKit

class PopoverAnimationManager: UIPresentationController, UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning {
    
    /// 记录当前是否是展现
    private var isPresent = false
    /// 记录当前菜单的尺寸
    var presentedFrame = CGRectZero
    
    // MARK: - 转场动画的代理方法 ------------------------------
    
    /**
    该方法用于告诉系统谁来负责自定义转场
    
    - parameter presented:  被展现的控制器
    - parameter presenting: 发起的控制器
    */
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        
        let pc = MHzPresentationController(presentedViewController: presented ,presentingViewController: presenting)
        pc.presentedFrame = presentedFrame
        
        return pc
    }
    
    /// 告诉系统谁来负责展现样式
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresent = true
        NSNotificationCenter.defaultCenter().postNotificationName(MHzPopoverViewControllerShowClick, object: self)
        return self
    }
    
    /// 告诉系统谁来负责消失样式
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        NSNotificationCenter.defaultCenter().postNotificationName(MHzPopoverViewControllerDismissClick, object: self)
        return self
    }
    
    /// 告诉系统展示和消失动画的时长
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    /**
     这个方法可以告诉系统，菜单如何展现
     无论是展现还是消失都会调用这个方法
     注意：只要实现了这个方法，那么系统就不会再管控制器如何弹出和消失，所有从c做都需要自己实现
     - parameter transitionContext: 包含了所有我们需要的参数
     */
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if isPresent
        {
            // 1.展现
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
            transitionContext.containerView()?.addSubview(toView!)
            // 2.执行动画
            toView?.transform = CGAffineTransformMakeScale(1.0, 0.0)
            toView?.layer.anchorPoint = CGPoint(x: 0.5, y: 0.0)
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                
                toView?.transform = CGAffineTransformIdentity
                
                }) { (_) -> Void in
                    // 如果自定义转场动画，那么必须告诉系统动画是否完成
                    transitionContext.completeTransition(true)
            }
            
        } else {
            
            // 消失
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                // 注意: 如果使用CGFloat之后发现运行的结果和我们预期的结果不一致, 那么可以尝试修改CGFloat的值为一个很小的值
                fromView?.transform = CGAffineTransformMakeScale(1.0, 0.0000001)
                
                }, completion: { (_) -> Void in
                    // 如果自定义转场动画，那么必须告诉系统动画是否完成
                    transitionContext.completeTransition(true)
            })
        }
        
        
    }
    
    
    
}
