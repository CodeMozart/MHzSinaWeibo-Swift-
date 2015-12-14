//
//  BaseTableViewController.swift
//  SinaWeibo
//
//  Created by Minghe on 11/6/15.
//  Copyright © 2015 Stanford swift. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {
    
    /// 记录用户是否登录
    var login = UserAccount.login()
    /// 访客视图
    var visitorView: VisitorView?
    
    
    override func loadView() {
        super.loadView()
        login ? super.loadView() : setupVisitorView()
    }
    
    // MARK: - 内部控制方法
    private func setupVisitorView()
    {
        // 1.加载xib视图
        visitorView = VisitorView.visitorView()
        view = visitorView
        
        // 2.监听按钮的点击事件
        visitorView?.registerBtn.addTarget(self, action: Selector("registerBtnClick"), forControlEvents: .TouchUpInside)
        visitorView?.loginBtn.addTarget(self, action: Selector("loginBtnClick"), forControlEvents: .TouchUpInside)
        
        // 3.添加导航条按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .Plain, target: self, action: Selector("registerBtnClick"))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .Plain, target: self, action: Selector("loginBtnClick"))
        
    }
    
    @objc private func registerBtnClick() {
        MHzLog("注册")
    }
   
    @objc private func loginBtnClick() {
        // 1.创建登陆界面
        let sb = UIStoryboard(name: "OAuthViewController", bundle: nil)
        let OAuthVC = sb.instantiateInitialViewController()!
        
        // 2.弹出登陆界面
        presentViewController(OAuthVC, animated: true, completion: nil)
    }
    
}
