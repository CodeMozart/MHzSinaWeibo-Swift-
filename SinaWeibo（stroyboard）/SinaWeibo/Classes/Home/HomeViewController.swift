//
//  HomeViewController.swift
//  SinaWeibo
//
//  Created by Minghe on 11/6/15.
//  Copyright © 2015 Stanford swift. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class HomeViewController: BaseTableViewController {

    // MARK: - 实例变量 ------------------------------
    var statuses: [Status]?
        {
        didSet{
            tableView.reloadData()
        }
    }
    
    // MARK: - 懒加载 ------------------------------
    /// 标题按钮
    private lazy var titleButton: TitleButton = {
        let btn = TitleButton()
        let title = UserAccount.loadUserAccount()!.screen_name ?? "性浪微博"
        btn.setTitle(title + "  ", forState: .Normal)
        btn.addTarget(self, action: Selector("titleButtonClick:"), forControlEvents: .TouchUpInside)
        return btn
    }()
    
    /// 负责自定义转场的对象
    private lazy var popoverManager: PopoverAnimationManager = {
        let manager = PopoverAnimationManager()
        manager.presentedFrame = CGRect(x: 87.5, y: 56, width: 200, height: 300)
        return manager
    }()
    
    
    // MARK: - viewDidLoad ------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        // 1.判断是否登录
        if !login {
            // 如果用户尚未登录，跳转到访客页面
            visitorView?.setupVisitorInfo(nil, title: "")
            return
        }
        
        // 2.初始化导航条
        setupNav()
        
        // 3.注册监听
        // (pop菜单显示和隐藏时，箭头方向都要改变)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("titleBtnChange"), name: MHzPopoverViewControllerShowClick, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("titleBtnChange"), name: MHzPopoverViewControllerDismissClick, object: nil)
        
        // 4.获取微博数据
        loadWeiboData()
        
        //
        tableView.estimatedRowHeight = 200
        
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    deinit
    {
        // 移除监听
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - 内部控制方法------------------------------
    
    /**
    初始化导航条
    */
    private func setupNav() {
        
        // 1添加左右按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention", target: self, action: Selector("friendBtnClick"))
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop", target: self, action: Selector("QRBtnClick"))
        
        // 2添加标题按钮
        navigationItem.titleView = titleButton
        
    }
    
    /// 点击左上角好友按钮
    @objc private func friendBtnClick() {
        MHzLog("")
    }
    
    /**
     右上角二维码按钮点击
     */
    @objc private func QRBtnClick() {
        //
        let sb = UIStoryboard(name: "QRCodeViewController", bundle: nil)
        let QRCodeVC = sb.instantiateInitialViewController()!
        
        //
        presentViewController(QRCodeVC, animated: true, completion: nil)
    }
    
    
    /// 控制标题按钮箭头的方向
    @objc private func titleBtnChange() {
        titleButton.selected = !titleButton.selected
    }

    /**
     点击标题按钮
     */
    @objc private func titleButtonClick(titleButton: UIButton) {

        // 2.
        let sb = UIStoryboard(name: "PopoverController", bundle: nil)
        let popVC = sb.instantiateInitialViewController()
        //
        popVC?.transitioningDelegate = popoverManager
        popVC?.modalPresentationStyle = .Custom
        // 3.
        presentViewController(popVC!, animated: true, completion: nil)
        
    }
    
    /// 获取微博数据
    private func loadWeiboData() {
        NetworkTools.shareInstance.loadStatus { (dicts, error) -> () in
            
            // 1.安全校验
            if error != nil {
                SVProgressHUD.showErrorWithStatus("获取微博数据失败",maskType: .Black)
                return
            }
            
            guard let dictArray = dicts else {
                SVProgressHUD.showErrorWithStatus("没有获取到微博数据",maskType: .Black)
                return
            }
            
            // 2.遍历字典数组，处理微博数据
            var models = [Status]()
            for dict in dictArray {
                models.append(Status(dict: dict))
                
            }
            
            // 3.缓存配图
            

            self.statuses = models
        }
    }
    
    /// 缓存配图
    private func cacheImage(list: [Status]) {
        let group = dispatch_group_create()
        
        for status in list {
            
            guard let urls = status.pic_urls else {
                continue
            }
            
            for dict in urls {
                
                let urlStr = dict["thumbnail_pic"] as? String
                let url = NSURL(string: urlStr ?? "")
                
                dispatch_group_enter(group)
                
                SDWebImageManager.sharedManager().downloadImageWithURL(url, options: SDWebImageOptions(rawValue: 0), progress: nil, completed: { (_, error, _, _, _) -> Void in
                    
                    MHzLog("图片下载完成")
                    
                    dispatch_group_leave(group)
                })
                
            }
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
            MHzLog("所有图片下载完成")
            self.statuses = list
        }
    }
    
   
}


extension HomeViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return statuses?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as! MHzTableViewCell
        
        let status = statuses![indexPath.row]
        cell.status = status
        
        return cell
    }
}






