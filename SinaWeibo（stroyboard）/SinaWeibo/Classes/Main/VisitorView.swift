//
//  VisitorView.swift
//  SinaWeibo
//
//  Created by Minghe on 11/6/15.
//  Copyright © 2015 Stanford swift. All rights reserved.
//

import UIKit

class VisitorView: UIView {

    // 转盘
    @IBOutlet weak var turntableView: UIImageView!
    // 大图标
    @IBOutlet weak var iconView: UIImageView!
    // 文本视图
    @IBOutlet weak var titleView: UILabel!
    // 注册按钮
    @IBOutlet weak var registerBtn: UIButton!
    // 登录按钮
    @IBOutlet weak var loginBtn: UIButton!
    
    /**
     快速创建方法
     
     - returns: xib加载的访客页面
     */
    class func visitorView() -> VisitorView {
        return NSBundle.mainBundle().loadNibNamed("VisitorView", owner: nil, options: nil).last as! VisitorView
    }
    
    // MARK: - 外部控制方法
    func setupVisitorInfo(imageName: String?, title: String)
    {
        // homepage 
        // (因为xib绘制的就是首页的样子，所以首页在调用这个方法的时候不给imageName赋值，这样就可以直接进到else)
        guard let name = imageName else
        {
            startAnimation()
            return
        }
        
        // other pages
        iconView.image = UIImage(named: name)
        titleView.text = title
        turntableView.hidden = true
    }
    
     // MARK: - 内部控制方法
    private func startAnimation()
    {
        // 1.创建动画对象
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        // 2.设置动画属性
        anim.toValue = 2 * M_PI
        anim.duration = 10.0
        anim.repeatCount = MAXFLOAT
        
        // 2.1告诉系统不要随便移除动画，只有当控件销毁的时候才需要移除
        anim.removedOnCompletion = false
        // 3.将动画添加到图层
        turntableView.layer.addAnimation(anim, forKey: nil)
    }
    


}
