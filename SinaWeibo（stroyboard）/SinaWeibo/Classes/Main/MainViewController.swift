//
//  MainViewController.swift
//  SinaWeibo
//
//  Created by Minghe on 11/6/15.
//  Copyright © 2015 Stanford swift. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // 不写在viewDidLoad中，因为会被自带控件挡住
        
        // 1.添加自定义按钮到tabbar上
        tabBar.addSubview(composeButton)
        // 2.计算按钮的宽高
        let width : CGFloat = tabBar.bounds.width / CGFloat(childViewControllers.count)
        let height : CGFloat = composeButton.bounds.height
        // 3.调整按钮的位置
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        composeButton.frame = CGRectOffset(rect, 2 * width, 0)
    }


    

    // MARK: - 内部控制方法
    /// 监听加号按钮点击
    @objc private func composeBtnClick() {
        MHzLog("点击了按钮")
    }
    
    // MARK: - 懒加载
    /**
    *  懒加载中间的发布按钮
    */
    private lazy var composeButton: UIButton = {
        
        let btn = UIButton(imageName: "tabbar_compose_icon_add", backgroundImage: "tabbar_compose_button")
        btn.addTarget(self, action: Selector("composeBtnClick"), forControlEvents: .TouchUpInside)
        
        return btn
        
    }()
    
    
}
