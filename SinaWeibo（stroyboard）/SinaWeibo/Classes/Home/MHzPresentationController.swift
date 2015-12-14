//
//  MHzPresentationController.swift
//  SinaWeibo
//
//  Created by Minghe on 11/9/15.
//  Copyright © 2015 Stanford swift. All rights reserved.
//

import UIKit

class MHzPresentationController: UIPresentationController {

    /// 记录菜单的尺寸
    var presentedFrame = CGRectZero
    
    /// 布局被弹出的控制器
    override func containerViewWillLayoutSubviews() {
        
        super.containerViewWillLayoutSubviews()
        // containerView 容器视图
        // presentedView 被展现的视图（当前就是弹出菜单控制器的view）
        
        // 1.添加蒙板（和整个屏幕一样大的，装载菜单的view,被设置成了透明色，所以可以看到后面的控制器）
        containerView?.insertSubview(cover, atIndex: 0)
        cover.frame = containerView!.bounds

        // 2.修改被展现视图尺寸（菜单）
//        presentedView()?.frame = CGRect(x: 87.5, y: 56, width: 200, height: 200)
        presentedView()?.frame = presentedFrame
    }
    
    
    // MARK: - 内部控制方法 ------------------------------
    @objc private func coverClick()
    {
        //  关闭菜单
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - 懒加载 ------------------------------
    private lazy var cover: UIView = {
        // 1.
        let otherView = UIView()
        otherView.backgroundColor = UIColor(white: 0.8, alpha: 0.5)
        // 2.
        let tap = UITapGestureRecognizer(target: self, action: Selector("coverClick"))
        otherView.addGestureRecognizer(tap)
        
        return otherView
    }()
}
